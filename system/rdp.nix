# https://gist.github.com/hermannolafs/c1379a090350d2dc369aeabd3c0d8de3
{ pkgs, lib, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3389 ];
    allowedUDPPorts = [ 3389 ];
  };
  services.xrdp = {
    enable = true;
    defaultWindowManager = lib.getExe pkgs.gnome3.gnome-session;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs.gnome3; [ gnome-session ];
}
