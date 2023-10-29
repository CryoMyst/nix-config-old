{
  description = "My NixOS Configuration";

  inputs = {
    # Nixpkgs is pinned to nixos-unstable by default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager is pinned to the latest release on GitHub
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland + Hy3
    hyprland.url = "github:hyprwm/Hyprland";
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Development 
    rust-overlay.url = "github:oxalica/rust-overlay";
    devenv.url = "github:cachix/devenv";
  };

  outputs = { self, nixpkgs, home-manager, ... } @inputs: {
    nixpkgs.overlays = [ 
      self.inputs.rust-overlay.overlays.default
    ];

    nixosConfigurations = {
      cryo-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ 
          ./system/cryo-desktop/configuration.nix 
        ];
      };
    };
  };
}
