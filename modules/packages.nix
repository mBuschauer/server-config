{ pkgs, secrets, settings, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nano
    wget
    git

    lunarvim # better vim
    bottom # better top

    yazi # file viewer
    lsd # better ls
    bat # better cat 
    trashy # alternative to rm
    zip # zip files
    unzip # unzip files

    nil
    nixpkgs-fmt

    kitty # terminal emulator I usually use
    wezterm # switched to wezterm recently

    fastfetch
    ncdu

    busybox
  ];

  home-manager.users.${settings.username} = {
    programs.gh = {
      enable = true;
      extensions = [ pkgs.gh-notify ];
      package = pkgs.gh;
    }; 
  };

  programs.git = {
    enable = true;
    config = {
      commit = {
        gpgSign = true;
      };
      gpg = {
        program = "${pkgs.gnupg}/bin/gpg";
      };
      merge = {
        "ours" = {
          driver = true;
        };
      };
      tag = {
        gpgSign = true;
      };
      user = {
        name = secrets.gitUser;
        email = secrets.gitEmail;
        signingKey = secrets.gpgFingerprint;
      };

    };
  };

  # for creating gpg keys
  services.pcscd.enable = true;
  programs.gnupg = {
    package = pkgs.gnupg;
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  programs.tmux = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  virtualisation.docker.enable = true;
}
