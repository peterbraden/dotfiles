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
    linger = true;
  };

  systemd.user.services.chezmoi-init-peterbraden = {
    unitConfig = {
      Description = "Initialize chezmoi for peterbraden";
      After = [
        "network-online.target"
        "ssh-agent.service"
      ];
      # Give up after five failures in an hour rather than retry forever.
      StartLimitIntervalSec = 3600;
      StartLimitBurst = 5;
    };
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
      # No TTY in a service: the template's prompts take their per-host
      # defaults. Without this every start failed ("could not open a new
      # TTY") and restarted every 5 s.
      ExecStart = "${pkgs.chezmoi}/bin/chezmoi init peterbraden --apply --promptDefaults";
      Restart = "on-failure";
      RestartSec = 60;
    };
  };
}
