{ pkgs, ... }:
{
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs.gnome; [
      nautilus
      gnome-terminal
      gnome-system-monitor
      dconf-editor
    ];
    gnome.excludePackages = with pkgs; [ gnome-tour ];
  };
  services.xserver = {
    enable = true;
    desktopManager = {
      gnome = {
        enable = true;
      };
    };
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "guest";
      };
    };
    excludePackages = with pkgs; [ xterm ];
  };
  services.gnome.core-utilities.enable = false;
  # Gnome themes
  programs.dconf.enable = true;
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
