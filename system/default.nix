{ lib', lib, ... }:
{
  imports = lib'.flocken.getModules ./.;
  # networking.useDHCP = false;
  # networking.firewall.enable = false;

  system.stateVersion = lib.trivial.release;
  powerManagement.enable = false;

  programs.git.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
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

  time.timeZone = "Europe/Berlin";
}
