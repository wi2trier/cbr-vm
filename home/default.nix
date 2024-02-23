{ lib, lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  home.stateVersion = lib.trivial.release;
}
