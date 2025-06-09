{ pkgs, inputs, ... }:
let nessus-agent = pkgs.callPackage ./nessus-agent-default.nix { };
in {
  systemd.services.nessus-agent = {
    enable = true;
    description = "Tenable Nessus Sensor";
    unitConfig = { Type = "simple"; };
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = ''
        "${nessus-agent}/bin/nessus-agent-shell"
      '';
      Type = "oneshot";
      Restart = "no";
      TimeoutStopSec = "60s";
      KillMode = "process";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
