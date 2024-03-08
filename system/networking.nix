{ ... }:
{
  networking = {
    firewall.enable = false;
    useNetworkd = true;
    useDHCP = true;
  };
  systemd.network.wait-online.enable = false;
}
