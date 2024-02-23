{ ... }:
{
  networking = {
    firewall.enable = true;
    useNetworkd = true;
    useDHCP = false;
  };
  systemd.network.wait-online.enable = false;
}
