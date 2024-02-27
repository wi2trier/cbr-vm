{ modulesPath, ... }:
{
  imports = [ "${modulesPath}/virtualisation/qemu-vm.nix" ];
}
