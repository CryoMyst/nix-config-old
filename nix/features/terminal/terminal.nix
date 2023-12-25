{ pkgs, ... }: {
  imports  = [
    ./direnv/direnv.nix
    ./nvim/nvim.nix
    ./tmux/tmux.nix
    ./zsh/zsh.nix
  ];
}
