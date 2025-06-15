{ pkgs, lib, ... }:

# Taken from the following link, with minor changes
# https://discourse.nixos.org/t/setting-up-wireguard-in-a-network-namespace-for-selectively-routing-traffic-through-vpn/10252/8

let
  vpnDNS = "10.2.0.1";
  addr = "10.2.0.2";
  vethAddrInMainNetns = "10.86.80.78";
  vethAddrInVpnNetns = "10.86.80.79";
  allowedPorts = [{
    # qb
    port = 9000;
    localOnly = false;
  }];
in {
  # systemd service for creating arbitrarily-named network namespaces (netns)
  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
      ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
    };
  };

  # Creates the actual wg interface, then moves it into the "protonvpn" netns
  systemd.services.wg-protonvpn = {
    description = "wg network interface (protonvpn)";
    after = [ "netns@protonvpn.service" ];
    bindsTo = [ "netns@protonvpn.service" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = let
      ip = "${pkgs.iproute2}/bin/ip";
      wg = "${pkgs.wireguard-tools}/bin/wg";
      iptables = "${pkgs.iptables}/bin/iptables";
    in {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writers.writeBash "wg-up" ''
        # Lots of this was copied from https://broadband.forum/threads/vpn-network-isolation-and-policy-routing-for-apps-like-qbittorrent.210005/
        set -ex
        # Create the WireGuard interface in the main netns
        ${ip} link add wg0 type wireguard
        # Move the interface to the VPN netns. See https://www.wireguard.com/netns/ for more details.
        ${ip} link set wg0 netns protonvpn
        # Add VPN IP addrs
        ${ip} -n protonvpn address add ${addr}/32 dev wg0
        ${ip} netns exec protonvpn \
        ${wg} setconf wg0 /etc/nixos/wireguard/wg0.conf
        # Bring up the wg interface in the VPN netns
        ${ip} -n protonvpn link set wg0 up

        # Create a routing table that routes all traffic through the wg interface. The table number does not matter
        ${ip} -n protonvpn route add default dev wg0 table 2468
        # Set all non-marked (non-fwmarked) traffic use that table
        ${ip} -n protonvpn rule add not fwmark 1 table 2468
        # Create a virtual ethernet (veth) interface between the main and VPN network namespaces
        ${ip} link add veth0 type veth peer name veth1 netns protonvpn
        # Add IP addresses for the veth pair
        ${ip} -n protonvpn addr add ${vethAddrInVpnNetns}/31 dev veth1
        ${ip} addr add ${vethAddrInMainNetns}/31 dev veth0
        # Bring up the veth pair
        ${ip} -n protonvpn link set dev veth1 up
        ${ip} link set dev veth0 up
        ${ip} -n protonvpn route add default via ${vethAddrInMainNetns} dev veth1
        # Set packets coming in to allowed ports to bypass normal routing and NAT via veth to netns, but only if from this machine or Tailscale
        ${lib.concatMapStringsSep "\n" (x:
          "${iptables} -t nat -A PREROUTING -p tcp --dst 127.0.0.1 --dport ${
            toString x.port
          } -j DNAT --to ${vethAddrInVpnNetns}") allowedPorts}
        # Mark incoming packets from veth1 on allowed ports with 0x1
        ${lib.concatMapStringsSep "\n" (x:
          "${ip} netns exec protonvpn ${iptables} -A PREROUTING -t mangle -i veth1 -p tcp --dport ${
            toString x.port
          } -j MARK --set-mark 1") allowedPorts}
        # Match those marked packets, and apply the same mark to the connection as a whole
        ${ip} netns exec protonvpn ${iptables} -A PREROUTING -t mangle -m mark --mark 0x1 -j CONNMARK --save-mark
        # Match those marked packets, and apply the same mark to the connection as a whole
        ${ip} netns exec protonvpn ${iptables} -A PREROUTING -t mangle -m mark --mark 0x1 -j CONNMARK --save-mark
        # Restore the mark from the connection as a whole to the specific packet, allowing it to actually exit via the veth
        ${ip} netns exec protonvpn ${iptables} -A OUTPUT -t mangle -j CONNMARK --restore-mark

        # Route all packets heading to Tailscale devices to exit the netns via the veth
        # Mark all packets coming from the netns via the veth to tailscale devices
        ${iptables} -t mangle -A PREROUTING -i veth0 --dst 100.64.0.0/10 -j MARK --set-mark 13
        # Match these marked packets, and apply the mark to the connection as a whole
        ${iptables} -t mangle -A PREROUTING -m mark --mark 13 -j CONNMARK --save-mark
        # Restore the mark from the connection as a whole to specific packets
        ${iptables} -t mangle -A OUTPUT -j CONNMARK --restore-mark
        # Set the source address for outgoing packets to this machine's tailscale IP, so that the device it's connecting to can complete the handshake

        # DNS rules
        ${ip} netns exec protonvpn ${iptables} -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to ${vpnDNS}
        ${ip} netns exec protonvpn ${iptables} -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to ${vpnDNS}
      '';
      ExecStop = pkgs.writers.writeBash "wg-down" ''
        set -ex

        # DNS rules
        ${ip} netns exec protonvpn ${iptables} -t nat -D OUTPUT -p udp --dport 53 -j DNAT --to ${vpnDNS}
        ${ip} netns exec protonvpn ${iptables} -t nat -D OUTPUT -p tcp --dport 53 -j DNAT --to ${vpnDNS}
        ${ip} netns exec protonvpn ${iptables} -D PREROUTING -t mangle -m mark --mark 0x1 -j CONNMARK --save-mark
        ${ip} netns exec protonvpn ${iptables} -D OUTPUT -t mangle -j CONNMARK --restore-mark

        # Delete the firewall rules created above (`-A` is "append to chain", `-D` is "delete matching rule from chain")
        ${lib.concatMapStringsSep "\n" (x:
          "${ip} netns exec protonvpn ${iptables} -D PREROUTING -t mangle -i veth1 -p tcp --dport ${
            toString x.port
          } -j MARK --set-mark 1") allowedPorts}
        ${ip} netns exec protonvpn ${iptables} -D PREROUTING -t mangle -m mark --mark 0x1 -j CONNMARK --save-mark
        ${ip} netns exec protonvpn ${iptables} -D OUTPUT -t mangle -j CONNMARK --restore-mark
        ${lib.concatMapStringsSep "\n" (x:
          "${iptables} -t nat -D PREROUTING -p tcp --dst 127.0.0.1 --dport ${
            toString x.port
          } -j DNAT --to ${vethAddrInVpnNetns}") allowedPorts}

        ${ip} link del veth0

        ${ip} -n protonvpn rule del not fwmark 1 table 2468

        # Delete the default routes. I don't even think this is necessary
        # ${ip} -n protonvpn route del default dev wg0
        # Delete the WireGuard interface itself
        ${ip} -n protonvpn link del wg0
      '';
    };
  };

  # Sets DNS in the network namespace to go through the tunnel
  environment.etc."netns/protonvpn/resolv.conf" = {
    text = "nameserver ${vpnDNS}";
    mode = "0644";
  };
}
