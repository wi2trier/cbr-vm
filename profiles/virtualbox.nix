{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/virtualbox-image.nix")
    (modulesPath + "/profiles/clone-config.nix")
  ];

  services.xserver.videoDrivers = [ "virtualbox" ];

  # https://github.com/NixOS/nixpkgs/issues/243671#issuecomment-1822983422
  services.xserver.displayManager.sessionCommands =
    let
      inherit (config.boot.kernelPackages) virtualboxGuestAdditions;
      path = lib.makeBinPath (
        with pkgs;
        [
          gnugrep
          xorg.xorgserver.out
          which
        ]
      );
    in
    ''
      PATH="${path}:$PATH"  ${lib.getExe' virtualboxGuestAdditions "VBoxClient"} --vmsvga
    '';
}
