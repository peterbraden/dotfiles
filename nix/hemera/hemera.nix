{ config, pkgs, lib, ... }: {
  imports = [
    ../common/apps.nix
    ../common/users.nix
    ../common/ssh.nix
  ];

  nix.settings.system-features = [ "nix-command" "flakes"];                
  nix.extraOptions = "experimental-features = nix-command flakes"; 

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  networking.hostName = "hemera";

  environment.systemPackages = with pkgs; [
    # Sway WM
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    waybar

    alacritty
    firefox
  ];

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # Auto-login for development VM convenience.
  services.getty.autologinUser = "peterbraden";

  # Enable lingering so user services run even without login.
  systemd.services.enable-linger-peterbraden = {
    description = "Enable lingering for peterbraden";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.systemd}/bin/loginctl enable-linger peterbraden";
    };
  };

  system.stateVersion = "24.11";
}
