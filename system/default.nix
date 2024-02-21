{
  lib',
  lib,
  inputs,
  pkgs,
  ...
}:
let
  python = pkgs.python3.withPackages (ps: with ps; [ pip ]);
in
{
  imports = lib'.flocken.getModules ./.;

  system.stateVersion = lib.trivial.release;
  powerManagement.enable = false;
  time.timeZone = "Europe/Berlin";

  documentation.nixos.enable = false;

  # HACK: Otherwise, PyCharm will not find the Python interpreter
  system.activationScripts.python.text = ''
    ln -fs ${python}/bin/* /usr/bin/
  '';

  nixpkgs = {
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    nixPath = lib.mkForce [ "nixpkgs=flake:nixpkgs" ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "impure-derivations"
        "ca-derivations"
        "repl-flake"
      ];
    };
  };
}
