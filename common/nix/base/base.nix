{ pkgs, ... }: {
  nix = { 
    settings = { 
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      # interval = { Weekday = 0; Hour = 0; Minute = 0; };
      # options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };
  system.stateVersion = "unstable-01";
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;
}
