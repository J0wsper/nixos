# https://github.com/matrss/nixpkgs/commit/35523c1752ade441277a6f70a25db29fe06f6334
{ lib, buildFHSEnv, writeShellScriptBin, dpkg, ... }:
let
  pname = "nessus-agent";
  version = "10.7.4";
  arch = "amd64";
  src = /opt/nessus_agent + "/NessusAgent-${version}-debian10_${arch}.deb";
  nessus-agent-install = writeShellScriptBin "nessus-agent-install" ''
    set -euo pipefail
    if [ -d /opt/nessus_agent ]; then
      echo "Nessus Agent already installed to /opt/nessus_agent"
      exit 0
    fi
    ${dpkg}/bin/dpkg-deb -x ${src}
    mv * ./opt/nessus_agent
    echo "Nessus Agent installed to /opt/nessus_agent"
  '';

in buildFHSEnv {
  name = "nessus-agent-shell";
  targetPkgs = pkgs:
    with pkgs; [
      nessus-agent-install
      coreutils
      tzdata
      nettools
      iproute2
      procps
      util-linux
    ];
  runScript = "bash -l";
  meta = with lib; {
    description = "Tenable Nessus Agent Installer";
    homepage = "https://www.tenable.com/products/nessus/nessus-agents";

    # license = licenses.unfree;
    maintainers = with maintainers; [ matrss ];
    platforms = platforms.linux;
  };
}
