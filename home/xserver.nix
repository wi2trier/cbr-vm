{ pkgs, lib, ... }:
let
  # https://askubuntu.com/a/1045962
  # https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html
  mkShortcut = (
    {
      name,
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
  shortcuts = [
    {
      name = "procake-docs";
      url = "https://procake.pages.gitlab.rlp.net/procake-wiki/";
      desktopName = "ProCAKE Docs";
      icon = ../assets/procake.jpg;
    }
    {
      name = "cbrkit-docs";
      url = "https://wi2trier.github.io/cbrkit/";
      desktopName = "CBRkit Docs";
      icon = ../assets/cbrkit.png;
    }
    {
      name = "eval-sheet";
      url = ../cbrkit-eval.pdf;
      desktopName = "Assignment Sheet";
      icon = "x-office-presentation";
    }
    {
      name = "eval-survey";
      url = "https://tally.so/r/wQ5xel";
      desktopName = "Feedback Survey";
      icon = "microphone";
    }
  ];
  iniFormat = pkgs.formats.ini { listToValue = values: lib.concatStringsSep ";" values; };
  mkSystemLink = name: "/run/current-system/sw/share/applications/${name}.desktop";
  mkUserLink = name: "/etc/profiles/per-user/guest/share/applications/${name}.desktop";
  mkShortcutLink = { name, ... }: mkUserLink name;
in
{
  home = {
    packages = builtins.map mkShortcut shortcuts;
  };
  xdg.configFile."xfce4/panel/docklike-3.rc".source = iniFormat.generate "docklike-config" {
    user = {
      pinned = [
        (mkSystemLink "thunar")
        (mkUserLink "chromium-browser")
        (mkUserLink "idea-community")
        (mkUserLink "pycharm-community")
      ] ++ (map mkShortcutLink shortcuts);
    };
  };
  xfconf.settings = {
    xsettings = {
      "Net/ThemeName" = "Adwaita-dark";
      "Net/IconThemeName" = "Adwaita";
      "Net/CursorThemeName" = "Adwaita";
    };
    xfce4-panel = {
      "configver" = 2;
      "panels" = [ 1 ];
      "panels/dark-mode" = true;
      "panels/panel-1/autohide-behavior" = 0;
      "panels/panel-1/icon-size" = 0;
      "panels/panel-1/length" = 100;
      "panels/panel-1/position" = "p=10;x=0;y=0";
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/size" = 48;
      # plugins
      "panels/panel-1/plugin-ids" = [
        1
        2
        3
        4
        5
        6
        7
        # 8
        9
      ];
      "plugins/plugin-1" = "whiskermenu";
      "plugins/plugin-2" = "separator";
      "plugins/plugin-2/expand" = false;
      "plugins/plugin-2/style" = 1;
      "plugins/plugin-3" = "docklike";
      "plugins/plugin-4" = "separator";
      "plugins/plugin-4/expand" = true;
      "plugins/plugin-4/style" = 0;
      "plugins/plugin-5" = "pager";
      "plugins/plugin-6" = "separator";
      "plugins/plugin-6/expand" = false;
      "plugins/plugin-6/style" = 0;
      "plugins/plugin-7" = "systray";
      "plugins/plugin-7/square-icons" = true;
      # "plugins/plugin-8" = "notification-plugin";
      "plugins/plugin-9" = "clock";
    };
  };
}
