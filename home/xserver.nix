{ pkgs, lib, ... }:
let
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
      categories = [ "Network" ];
    }
  );
  desktopLinks = builtins.mapAttrs mkDesktopLink {
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
  mkPackageLauncher = package: name: lib.singleton ("${package}/share/applications/${name}.desktop");
  mkLinkLauncher = name: mkPackageLauncher desktopLinks.${name} name;
in
{
  home = {
    packages = builtins.attrValues desktopLinks;
  };
  gtk.enable = true;
  xfconf.settings = {
    xfce4-panel = {
      "configver" = 2;
      "panels" = [
        1
        2
      ];
      "panels/dark-mode" = true;
      "panels/panel-1/icon-size" = 16;
      "panels/panel-1/length" = 100;
      "panels/panel-1/position" = "p=6;x=0;y=0";
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/size" = 26;
      "panels/panel-2/autohide-behavior" = 0;
      "panels/panel-2/length" = 1;
      "panels/panel-2/position" = "p=10;x=0;y=0";
      "panels/panel-2/position-locked" = true;
      "panels/panel-2/size" = 48;
      # plugins
      "panels/panel-1/plugin-ids" = [
        1
        2
        3
        4
        5
        6
        10
        5
        12
        5
        14
      ];
      "panels/panel-2/plugin-ids" = [
        21
        22
        20
        25
        26
        27
        20
        30
        31
      ];
      "plugins/plugin-1" = "applicationsmenu";
      "plugins/plugin-2" = "tasklist";
      "plugins/plugin-2/grouping" = 1;
      "plugins/plugin-3" = "separator";
      "plugins/plugin-3/expand" = true;
      "plugins/plugin-3/style" = 0;
      "plugins/plugin-4" = "pager";
      "plugins/plugin-5" = "separator";
      "plugins/plugin-5/style" = 0;
      "plugins/plugin-6" = "systray";
      "plugins/plugin-6/square-icons" = true;
      "plugins/plugin-10" = "notification-plugin";
      "plugins/plugin-12" = "clock";
      "plugins/plugin-14" = "actions";
      "plugins/plugin-20" = "separator";
      "plugins/plugin-21" = "showdesktop";
      "plugins/plugin-22" = "launcher";
      "plugins/plugin-22/items" = mkPackageLauncher pkgs.xfce.thunar "thunar";
      "plugins/plugin-25" = "launcher";
      "plugins/plugin-25/items" = mkPackageLauncher pkgs.chromium "chromium-browser";
      "plugins/plugin-26" = "launcher";
      "plugins/plugin-26/items" = mkPackageLauncher pkgs.jetbrains.idea-community "idea-community";
      "plugins/plugin-27" = "launcher";
      "plugins/plugin-27/items" = mkPackageLauncher pkgs.jetbrains.pycharm-community "pycharm-community";
      "plugins/plugin-30" = "launcher";
      "plugins/plugin-30/items" = mkLinkLauncher "procake-docs";
      "plugins/plugin-31" = "launcher";
      "plugins/plugin-31/items" = mkLinkLauncher "cbrkit-docs";
    };
  };
}
