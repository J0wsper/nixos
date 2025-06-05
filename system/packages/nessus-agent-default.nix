{ stdenv, lib, pkgs, zlib, autoPatchelfHook, dpkg, openssl, buildFHSEnv, inputs
, writeShellScriptBin, ... }:

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
    ${dpkg}/bin/dpkg-deb --fsys-tarfile '${src}' | tar x -C / ./opt/nessus_agent
    echo "Nessus Agent installed to /opt/nessus_agent"
  '';
  nessus-agent = stdenv.mkDerivation {
    inherit version arch src;
    name = pname;
    nativeBuildInputs = [ dpkg ];
    buildinputs = [ zlib autoPatchelfHook ];
    sourceRoot = ".";
    unpackPhase = ''
      dpkg-deb -x $src .
    '';
    installPhase = ''
      cp -r . $out
    '';
    meta = with lib; {
      description = "Tenable Nessus Agent";
      homepage = "https://www.tenable.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ J0wsper ];
    };
  };
in buildFHSEnv {
  name = "fs-bash";
  # TODO: It is not giving me an error about not being able to run
  # dynamically-linked executable intended for generic Linux distros out of the
  # box. I don't understand how this can happen with buildFHSEnv. I think the
  # problem is that it is searching for its dependencies in places it shouldn't.
  targetPkgs = pkgs:
    with pkgs; [
      openssl
      "${inputs.nasl}/bin/nasl-parse"
      nessus-agent-install
      nettools
      iproute2
      coreutils
    ];
  extraInstallCommands = ''
    ln -s ${nessus-agent}/* $out/
  '';
  runScript = "bash";
}
