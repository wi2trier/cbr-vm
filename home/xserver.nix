{ pkgs, lib, ... }:
let
  gnomeExtensions = with pkgs.gnomeExtensions; [ dash-to-panel ];
  desktopLinks = {
    cbrkit-docs = {
      url = "https://wi2trier.github.io/cbrkit/";
      desktopName = "CBRkit Docs";
      icon = ../assets/cbrkit.png;
    };
    procake-docs = {
      url = "https://procake.pages.gitlab.rlp.net/procake-wiki/";
      desktopName = "ProCAKE Docs";
      icon = ../assets/procake.jpg;
    };
  };
  # https://askubuntu.com/a/1045962
  mkDesktopLink = (
    name:
    {
      url,
      desktopName,
      icon,
    }:
    pkgs.makeDesktopItem {
      inherit name desktopName icon;
      comment = "Open ${desktopName}";
      terminal = false;
      exec = "chromium ${url}";
      noDisplay = false;
    }
  );
in
{
  home = {
    packages = gnomeExtensions ++ (lib.mapAttrsToList mkDesktopLink desktopLinks);
  };
  gtk = {
    enable = true;
    iconTheme.name = "Adwaita";
    theme.name = "Adwaita";
  };
  # dconf watch /
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = map (ext: ext.extensionUuid) gnomeExtensions;
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "chromium-browser.desktop"
        "code.desktop"
      ] ++ map (name: "${name}.desktop") (builtins.attrNames desktopLinks);
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = false;
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
  };
}
