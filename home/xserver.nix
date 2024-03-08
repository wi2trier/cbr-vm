{ pkgs, lib, ... }:
let
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
    packages = lib.mapAttrsToList mkDesktopLink desktopLinks;
  };
  xfconf.settings = { };
}
