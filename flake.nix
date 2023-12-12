{
  description = "My NixOS Configuration";

  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    devenv.url = "github:cachix/devenv";
    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
    userConfig = import ./config.nix;
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      inputs.nixpkgs.overlays = [
        inputs.rust-overlay.overlay 
        inputs.nur.overlay
      ];

      nixosConfigurations = {
        ${userConfig.computers.main-desktop.hostname} =
          let computerConfig = userConfig.computers.main-desktop;
          in nixpkgs.lib.nixosSystem {
            system = computerConfig.nix-system-type;
            specialArgs = inputs // {
              inherit computerConfig;
              inherit userConfig;
            };
            modules = [ ./system/${computerConfig.hostname}/configuration.nix ];
          };
        ${userConfig.computers.laptop-asahi.hostname} =
          let computerConfig = userConfig.computers.laptop-asahi;
          in nixpkgs.lib.nixosSystem {
            system = computerConfig.nix-system-type;
            specialArgs = inputs // {
              inherit computerConfig;
              inherit userConfig;
            };
            modules = [ ./system/${computerConfig.hostname}/configuration.nix ];
          };
      };
    };
}
