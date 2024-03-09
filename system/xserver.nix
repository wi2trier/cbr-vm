{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.xfce; [
    xfce4-docklike-plugin
    xfce4-whiskermenu-plugin
  ];
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
