{ ... }:
{
  networking = {
    firewall.enable = false;
    useNetworkd = true;
    useDHCP = false;
  };
  systemd.network.wait-online.enable = false;
}
