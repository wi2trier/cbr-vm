{ pkgs, ... }:
{
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages =
      (with pkgs.gnome; [
        nautilus
        gnome-system-monitor
        dconf-editor
      ])
      ++ (with pkgs; [ gnome-console ]);
    gnome.excludePackages = with pkgs; [ gnome-tour ];
  };
  services.xserver = {
    enable = true;
    desktopManager.gnome = {
      enable = true;
    };
    displayManager.gdm = {
      enable = true;
    };
    excludePackages = with pkgs; [ xterm ];
  };
  services.gnome.core-utilities.enable = false;
  # Gnome themes
  programs.dconf.enable = true;
}
