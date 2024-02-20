{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
          inherit inputs;
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
        systems = [ system ];
        flake = {
          nixosConfigurations = {
            base = nixpkgs.lib.nixosSystem { inherit modules system specialArgs; };
            virtualbox = nixpkgs.lib.nixosSystem {
              inherit system specialArgs;
              modules = modules ++ lib.singleton ./profiles/virtualbox.nix;
            };
          };
        };
        perSystem =
          { config, ... }:
          {
            packages = {
              default = config.packages.vm;
              vm = self.nixosConfigurations.default.config.system.build.vm;
              virtualbox = self.nixosConfigurations.virtualbox.config.system.build.virtualBoxOVA;
            };
          };
      }
    );
}
