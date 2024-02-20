{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = lib.singleton inputs.cbrkit.packages.${pkgs.system}.default.dependencyEnv;
}
