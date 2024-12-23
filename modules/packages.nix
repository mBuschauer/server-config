{ pkgs, ... }:
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
  ];

  programs.git = {
    enable = true;
    package = pkgs.git;
    config = [
      {
        user = {
          name = "${secrets.gitUser}";
          email = "${secrets.gitEmail}";
        };
      }
    ];
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
    settings = {
      X11Forwarding = true;
    };
  };

  virtualisation.docker.enable = true;
}
