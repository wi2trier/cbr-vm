# https://gist.github.com/hermannolafs/c1379a090350d2dc369aeabd3c0d8de3
# https://nixos.wiki/wiki/Remote_Desktop
{ pkgs, lib, ... }:
{
  services.xrdp = {
    enable = true;
    defaultWindowManager = lib.getExe' pkgs.xfce.xfce4-session "startxfce4";
    openFirewall = true;
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
            action.id == "org.freedesktop.color-manager.create-device" ||
            action.id == "org.freedesktop.color-manager.create-profile" ||
            action.id == "org.freedesktop.color-manager.delete-device" ||
            action.id == "org.freedesktop.color-manager.delete-profile" ||
            action.id == "org.freedesktop.color-manager.modify-device" ||
            action.id == "org.freedesktop.color-manager.modify-profile"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
}
