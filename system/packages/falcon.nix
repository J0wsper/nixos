# https://github.com/mbfr/nixos-setup/blob/master/falcon.nix
{ pkgs, inputs, env, cfg, ... }:
let
  falcon = pkgs.callPackage ./falcon-default.nix { };
  startPreScript = pkgs.writeScript "init-falcon" ''
    #! ${pkgs.bash}/bin/sh
    /run/current-system/sw/bin/mkdir -p /opt/CrowdStrike
    ln -sf ${falcon}/opt/CrowdStrike/* /opt/CrowdStrike
    ${falcon}/bin/fs-bash -c "${falcon}/opt/CrowdStrike/falconctl -g --cid"
  '';
in {
  systemd.tmpfiles.settings = {
    "10-crowdstrike" = {
      "/opt/CrowdStrike" = {
        d = {
          group = "falcon";
          user = "falcon";
          mode = "0770";
        };
      };
      "/var/log/falconctl.log" = {
        f = {
          group = "falcon";
          user = "falcon";
          mode = "0666";
        };
      };
    };
  };
  systemd.services.falcon-sensor = {
    description = "CrowdStrike Falcon Sensor";
    unitConfig.DefaultDependencies = false;
    after = [ "local-fs.target" "systemd-tmpfiles-setup.service" ];
    conflicts = [ "shutdown.target" ];
    before = [ "shutdown.target" ];

    serviceConfig = {
      StandardOutput = "journal";
      ExecStartPre = pkgs.writeShellScript "crowdstrike-prestart" ''
        ${falcon}/bin/fs-bash -c "${falcon}/opt/CrowdStrike/falconctl -s -f --cid=C87F75774D"
      '';
      ExecStart = ''
        ${falcon}/bin/fs-bash -c ${falcon}/opt/CrowdStrike/falcond
      '';
      Type = "forking";
      PIDFile = "/run/falcond.pid";
      Restart = "no";
      TimeoutStopSec = "60s";
      KillMode = "control-group";
      KillSignal = "SIGTERM";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
