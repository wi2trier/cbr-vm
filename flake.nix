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
        mkConfig =
          name: value:
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              ./formats/${name}.nix
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
        mkPackage = name: value: self.nixosConfigurations.${name}.config.system.build.${value};

        formats = {
          virtualbox = "virtualboxOVA";
          proxmox = "VMA";
          qemu = "vm";
        };
      in
      {
        systems = [ system ];
        flake = {
          nixosConfigurations = builtins.mapAttrs mkConfig formats;
          packages.${system} = builtins.mapAttrs mkPackage formats;
        };
      }
    );
}
