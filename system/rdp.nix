# https://gist.github.com/hermannolafs/c1379a090350d2dc369aeabd3c0d8de3
{ pkgs, lib, ... }:
let
  gnome-session = pkgs.gnome.gnome-session;
in
{
  services.xrdp = {
    enable = true;
    defaultWindowManager = lib.getExe' gnome-session "gnome-session";
    openFirewall = true;
  };

  environment.systemPackages = lib.singleton gnome-session;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
}
