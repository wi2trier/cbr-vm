{ pkgs, lib, ... }:
let
  python3 =
    with pkgs;
    writeShellScriptBin "python3" ''
      export LD_LIBRARY_PATH=${
        lib.makeLibraryPath [
          stdenv.cc.cc
          zlib
        ]
      }
      exec ${lib.getExe python3} "$@"
    '';
in
{
  system.activationScripts.python.text = ''
    ln -fs ${lib.getExe python3} /usr/bin/python3
  '';
}
