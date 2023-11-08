{ pkgs, home-manager, userConfig, ... }: {
  imports = [ (import "${home-manager}/nixos") ./user.nix ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users = {
    ${userConfig.username} = { home = { stateVersion = "23.05"; }; };
  };
}
