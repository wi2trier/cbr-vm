{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.xfce = {
      enable = true;
    };
    displayManager.lightdm = {
      enable = true;
    };
    excludePackages = with pkgs; [ xterm ];
    xkb.layout = "de";
  };
}
