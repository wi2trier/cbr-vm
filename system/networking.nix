{ ... }:
{
  networking = {
    networkmanager.enable = true;
    useNetworkd = true;
  };
  systemd.network.wait-online.enable = false;
  users.users.guest.extraGroups = [ "networkmanager" ];
}
