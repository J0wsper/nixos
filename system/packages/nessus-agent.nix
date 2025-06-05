{ pkgs, inputs, dpkg, ... }:
let
  nessus-agent =
    pkgs.callPackage ./nessus-agent-default.nix { inherit inputs; };
  startPreScript = pkgs.writeScript "nessusagent" ''
    #! ${pkgs.bash}/bin/sh
    /run/current-system/sw/bin/mkdir -p /opt/nessus_agent
    ln -sf ${nessus-agent}/opt/nessus_agent/* /opt/nessus_agent
  '';

in {
  systemd.services.nessus-agent = {
    enable = true;
    description = "Tenable Nessus Sensor";
    unitConfig.DefaultDependencies = false;
    after = [ "network.target" ];
    serviceConfig = {
      ExecStartPre = "${startPreScript}";
      ExecStart = ''
        ${nessus-agent}/bin/fs-bash -c "${nessus-agent}/opt/nessus_agent/sbin/nessus-service -q"
      '';
      ExecReload = ''
        ${nessus-agent}/bin/fs-bash -c "${nessus-agent}/usr/bin/pkill nessusd"
      '';
      Type = "forking";
      PIDFile = "/opt/nessus_agent/var/nessus/nessus-service.pid";
      Restart = "no";
      TimeoutStopSec = "60s";
      KillMode = "process";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
