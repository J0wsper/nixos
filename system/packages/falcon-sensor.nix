{ stdenv, lib, pkgs, dpkg, openssl, libnl, zlib, fetchurl, autoPatchelfHook
, buildFHSUserEnv, writeScript, ... }:

let
  pname = "falcon-sensor";
  version = "7.19.0-17219-1";
  arch = "amd64";
  src = /opt/CrowdStrike + "falcon-sensor_${version}_${arch}.deb";
  falcon-sensor = stdenv.mkDerivation {
    inherit version arch src;
    name = pname;

    buildInputs = [ dpkg zlib autoPatchelfHook ];

    sourceRoot = ".";

    unpackPhase = ''
      dpkg-deb -x $src $sourceRoot
    '';

    installPhase = ''
      cp -r $sourceRoot $out
    '';

    meta = with lib; {
      description = "CrowdStrike Falcon Sensor";
      homepage = "https://www.crowdstrike.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ J0wsper ];
    };
  };
in buildFHSUserEnv {
  name = "fs-bash";
  targetPkgs = pkgs: [ libnl openssl zlib ];

  extraInstallCommands = ''
    ln -s ${falcon-sensor}/* $out/
  '';

  runScript = "bash";
}

