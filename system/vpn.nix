{ config, pkgs, lib, ... }:

# Taken from the following link, with minor changes
# https://discourse.nixos.org/t/setting-up-wireguard-in-a-network-namespace-for-selectively-routing-traffic-through-vpn/10252/8

let
  vpnDNS = "10.128.0.1";
  addr = "10.132.177.85";
  vethAddrInMainNetns = "192.168.1.1";
  vethAddrInVpnNetns = "192.168.1.2";
  allowedPorts = [{
    port = 9000;
    localOnly = false;
  } # qb
    ];
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
        # Set the wg config. TODO: this file should not be in my user home directory
        ${ip} netns exec protonvpn \
        ${wg} setconf wg0 /etc/nixos/wireguard/wg0.conf
        # Bring up the wg interface in the VPN netns
        ${ip} -n protonvpn link set wg0 up
        # Route all IPv6 packets through the wg socket
        ${ip} -n protonvpn -6 route add default dev wg0

        # https://superuser.com/questions/764986/howto-setup-a-veth-virtual-network
        # https://medium.com/@amazingandyyy/introduction-to-network-namespaces-and-virtual-ethernet-veth-devices-304e0c02d084

        # TODO: Something is just completely fucked in here but I don't know what.

        # Create a routing table that routes all traffic through the wg interface. The table number does not matter
        ${ip} -n protonvpn route add default dev wg0 table 2468
        # Set all non-marked (non-fwmarked) traffic use that table
        ${ip} -n protonvpn rule add not fwmark 1 table 2468
        # Create a virtual ethernet (veth) interface between the main and VPN network namespaces
        ${ip} link add veth0 type veth peer name veth1 netns protonvpn
        # Giving both ends an IP address
        ${ip} addr add ${vethAddrInMainNetns}/32 dev veth0
        ${ip} -n protonvpn addr add ${vethAddrInVpnNetns}/32 dev veth1
        # Putting up the links
        ${ip} link set dev veth0 up
        ${ip} link set dev lo up
        ${ip} -n protonvpn link set dev lo up
        ${ip} -n protonvpn link set dev veth1 up
        # Routing traffic
        ${ip} route add ${vethAddrInVpnNetns}/32 dev veth0
        ${ip} -n protonvpn route add ${vethAddrInMainNetns}/32 dev veth1
      '';
    };
  };

  # Sets DNS in the network namespace to go through the tunnel
  environment.etc."netns/protonvpn/resolv.conf" = {
    text = "nameserver ${vpnDNS}";
    mode = "0644";
  };

}
