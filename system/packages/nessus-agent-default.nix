# https://github.com/matrss/nixpkgs/commit/35523c1752ade441277a6f70a25db29fe06f6334
{ pkgs ? import <nixpkgs> { } }:

let
  pname = "nessus-agent";
  version = "10.7.4";
  arch = "amd64";
  src = /opt/nessus_agent + "/NessusAgent-${version}-debian10_${arch}.deb";
  nessus-agent-install = pkgs.writeShellScriptBin "nessusagentinstall" ''
    ${pkgs.dpkg}/bin/dpkg-deb -x ${src} .
    mv * $out
    echo "Nessus Agent installed to /opt/nessus_agent"
  '';

in pkgs.buildFHSEnv {
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
}
