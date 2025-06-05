# https://github.com/mbfr/nixos-setup/blob/master/falcon.nix
{ pkgs, ... }:
let
  falcon = pkgs.callPackage ./falcon-default.nix { };
  startPreScript = pkgs.writeScript "init-falcon" ''
    #! ${pkgs.bash}/bin/sh
    /run/current-system/sw/bin/mkdir -p /opt/CrowdStrike
    ln -sf ${falcon}/opt/CrowdStrike/* /opt/CrowdStrike
    ${falcon}/bin/fs-bash -c "${falcon}/opt/CrowdStrike/falconctl -g --cid"
  '';
in {
  systemd.services.falcon-sensor = {
    enable = true;
    description = "CrowdStrike Falcon Sensor";
    unitConfig.DefaultDependencies = false;
    after = [ "local-fs.target" ];
    conflicts = [ "shutdown.target" ];
    before = [ "sysinit.target" "shutdown.target" ];
    serviceConfig = {
      ExecStartPre = "${startPreScript}";
      ExecStart =
        ''${falcon}/bin/fs-bash -c "${falcon}/opt/CrowdStrike/falcond"'';
      Type = "forking";
      PIDFile = "/run/falcond.pid";
      Restart = "no";
      TimeoutStopSec = "60s";
      KillMode = "process";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.tmpfiles.settings = {
    "10-crowdstrike" = {
      "/opt/CrowdStrike" = {
        d = {
          group = "root";
          user = "root";
          mode = "0770";
        };
      };
      "/var/log/falconctl.log" = {
        f = {
          group = "root";
          user = "root";
          mode = "0660";
        };
      };
    };
  };
}
