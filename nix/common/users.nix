{ inputs, config, pkgs, lib,  ... }:{

  programs.zsh.enable = true;

  users.users.peterbraden = {
    description = "Peter Braden";

    createHome = true;

    openssh.authorizedKeys.keyFiles = [ inputs.ssh-keys.outPath ];

    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];

    # Generate w' podman run -it --rm alpine mkpasswd -m sha512 'PASSWORD'
    # temporary password from ali-baba
    initialHashedPassword =  "$6$MLmnUA9WQN5ez1yh$YMACqIQIQmkXVeGKOCMDo9TPoqYiuGBTiVP/zcQYM6ToLUWpcUyku0f69VZPwA0mN5NOV5EKfC4riwKVYarwl.";

    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Run chezmoi init to setup dotfiles as a system service.
  systemd.services.chezmoi-init-peterbraden = {
    description = "Initialize chezmoi for peterbraden";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "peterbraden";
      ExecStart = "${pkgs.chezmoi}/bin/chezmoi init peterbraden --apply";
    };
  };
}
