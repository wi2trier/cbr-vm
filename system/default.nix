{
  lib',
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  system.stateVersion = lib.trivial.release;
  powerManagement.enable = false;
  time.timeZone = "Europe/Berlin";

  documentation.nixos.enable = false;

  nixpkgs = {
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    config = {
      allowUnfree = true;
    };
  };

  # otherwise, python venvs will not work
  environment.variables.LD_LIBRARY_PATH = lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
    pkgs.zlib
  ];

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
