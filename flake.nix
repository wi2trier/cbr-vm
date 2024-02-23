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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
      nixos-generators,
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
        mkSystem =
          module:
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              module
              ./system
              home-manager.nixosModules.home-manager
              nixos-generators.nixosModules.all-formats
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
        defaultSystem = mkSystem { };
        system = "x86_64-linux";
      in
      {
        systems = [ system ];
        flake = {
          nixosConfigurations = {
            virtualbox = mkSystem "${nixpkgs}/nixos/modules/virtualisation/virtualbox-image.nix";
            proxmox = mkSystem "${nixpkgs}/nixos/modules/virtualisation/proxmox-image.nix";
          };
          legacyPackages.${system} = defaultSystem.config.formats;
        };
      }
    );
}
