{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flocken = {
      url = "github:mirkolenz/flocken/v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      systems,
      home-manager,
      flocken,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      let
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          lib' = {
            flocken = flocken.lib;
          };
        };
        mkNixosConfiguration =
          name:
          { module, ... }:
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              module
              ./system
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  users.guest.imports = [ ./home ];
                };
              }
            ];
          };
        mkNixosGenerator =
          name: { generator, ... }: self.nixosConfigurations.${name}.config.system.build.${generator};

        configurations = {
          virtualbox = {
            module = "${nixpkgs}/nixos/modules/virtualisation/virtualbox-image.nix";
            generator = "virtualboxOVA";
          };
          proxmox = {
            module = "${nixpkgs}/nixos/modules/virtualisation/proxmox-image.nix";
            generator = "VMA";
          };
        };
      in
      {
        systems = [ system ];
        flake = {
          nixosConfigurations = builtins.mapAttrs mkNixosConfiguration configurations;
          legacyPackages.${system} = builtins.mapAttrs mkNixosGenerator configurations;
        };
      }
    );
}
