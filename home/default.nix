{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  home.stateVersion = "23.11";
}
