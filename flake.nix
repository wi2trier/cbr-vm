{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flocken = {
      url = "github:mirkolenz/flocken/v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cbrkit = {
      url = "github:wi2trier/cbrkit";
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
      nixos-generators,
      flocken,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      let
        specialArgs = {
          lib' = {
            flocken = flocken.lib;
          };
        };
        modules = [
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
        system = "x86_64-linux";
      in
      {
        systems = import systems;
        flake = {
          nixosConfigurations = {
            default = nixpkgs.lib.nixosSystem { inherit modules system specialArgs; };
            virtualbox = nixpkgs.lib.nixosSystem {
              inherit system specialArgs;
              modules = modules ++ lib.singleton ./profiles/virtualbox.nix;
            };
            # https://www.tweag.io/blog/2023-02-09-nixos-vm-on-macos/
            darwinvm = nixpkgs.lib.nixosSystem {
              inherit system specialArgs;
              modules =
                modules
                ++ lib.singleton {
                  virtualisation.vmVariant.virtualisation.host.pkgs = import nixpkgs { system = "x86_64-darwin"; };
                };
            };
          };
          packages.x86_64-linux = {
            default = self.nixosConfigurations.default.config.system.build.vm;
            virtualbox = self.nixosConfigurations.virtualbox.config.system.build.virtualBoxOVA;
            # virtualbox = nixos-generators.nixosGenerate {
            #   inherit system modules;
            #   format = "virtualbox";
            # };
          };
          packages.x86_64-darwin = {
            default = self.nixosConfigurations.darwinvm.config.system.build.vm;
          };
        };
      }
    );
}
