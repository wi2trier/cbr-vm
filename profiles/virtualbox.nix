{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/virtualbox-image.nix")
    (modulesPath + "/profiles/clone-config.nix")
  ];

  services.xserver.videoDrivers = [ "virtualbox" ];
}
