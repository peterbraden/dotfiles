{ config, pkgs, lib, ...}: {

  # Packages I want installed  _everywhere_,
  # ie, no host specific, windowmanagers etc.
  environment.systemPackages = with pkgs; [
    chezmoi
    git
    neovim
    zsh
  ];

}
