{ config, pkgs, lib, ...}: {

  # Packages I want installed  _everywhere_,
  # ie, no host specific, windowmanagers etc.
  environment.systemPackages = with pkgs; [
    chezmoi
    curl
    git
    less
    lsof
    neovim
    tmux
    unzip
    zsh
  ];

}
