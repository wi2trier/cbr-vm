{ ... }:
{
  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };
  systemd.network.wait-online.enable = false;
}
