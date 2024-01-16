{
  description = "My NixOS Configuration";

  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    devenv.url = "github:cachix/devenv";
    nixos-apple-silicon.url = "github:yu-re-ka/nixos-m1/nixos-unstable-fixes";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
      flake-config = import ./config.nix;
      user-config = flake-config.user;
    in {
      nixosConfigurations = {
        ${flake-config.computers.main-desktop.hostname} =
          let 
            computer-config = flake-config.computers.main-desktop;
          in nixpkgs.lib.nixosSystem {
            system = computer-config.system-type;
            specialArgs = inputs // {
              inherit user-config;
              inherit computer-config;
              inherit flake-config;
            };
            modules = [
              ./systems/${computer-config.hostname}/configuration.nix 
            ];
          };
        ${flake-config.computers.work-macbook.hostname} =
          let computer-config = flake-config.computers.work-macbook;
          in nixpkgs.lib.nixosSystem {
            system = computer-config.system-type;
            specialArgs = inputs // {
              inherit user-config;
              inherit computer-config;
              inherit flake-config;
            };
            modules = [
              ./systems/${computer-config.hostname}/configuration.nix 
            ];
          };
      };
    };
}
