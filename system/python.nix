{ pkgs, lib, ... }:
let
  python3 = pkgs.writeShellScriptBin "python3" ''
    export LD_LIBRARY_PATH=${
      lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
        pkgs.zlib
      ]
    }
    exec ${lib.getExe pkgs.python3} "$@"
  '';
in
{
  system.activationScripts.python.text = ''
    ln -fs ${lib.getExe python3} /usr/bin/python3
  '';
}
