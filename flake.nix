{
  description = "My NixOS Configuration";

  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    
    nur.url = "github:nix-community/nur";
    devenv.url = "github:cachix/devenv";
    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
      flake-config = import ./config.nix;
      user-config = flake-config.user;
    in {
      nixosConfigurations = nixpkgs.lib.mapAttrs' (
        name: value: nixpkgs.lib.nameValuePair (
          value.hostname
        ) (
          let 
            computer-config = value;
          in nixpkgs.lib.nixosSystem rec {
            system = computer-config.system-type;
            specialArgs = inputs // {
              inherit user-config;
              inherit computer-config;
              inherit flake-config;
              nixpkgs-stable = import inputs.nixpkgs-stable { inherit system; };
              nixpkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
              nixpkgs-master = import inputs.nixpkgs-master { inherit system; };
            };
            modules = [
              ./systems/${computer-config.hostname}/configuration.nix 
            ];
          }
        )
      ) flake-config.computers;
    };
}
