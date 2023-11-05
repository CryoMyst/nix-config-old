{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland.url = "github:hyprwm/Hyprland";
    # hy3 = {
    #   url = "github:outfoxxed/hy3";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    rust-overlay.url = "github:oxalica/rust-overlay";
    devenv.url = "github:cachix/devenv";
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs:
  let
    userConfig = import ./config.nix;
  in {
    # Setup overlays
    nixpkgs.overlays = [ 
      self.inputs.rust-overlay.overlays.default
    ];

    nixosConfigurations = {
      ${userConfig.computers.main-desktop.hostname} = 
      let
        computerConfig = userConfig.computers.main-desktop;
      in nixpkgs.lib.nixosSystem {
        system = computerConfig.nix-system-type;
        specialArgs = inputs // {
          inherit computerConfig;
          inherit userConfig;
        };
        modules = [
          ./system/${computerConfig.hostname}/configuration.nix
        ];
      };
      ${userConfig.computers.laptop-asahi.hostname} = 
      let
        computerConfig = userConfig.computers.laptop-asahi;
      in nixpkgs.lib.nixosSystem {
        system = computerConfig.nix-system-type;
        specialArgs = inputs // {
          inherit computerConfig;
          inherit userConfig;
        };
        modules = [
          ./system/${computerConfig.hostname}/configuration.nix
        ];
      };
    };
  };
}
