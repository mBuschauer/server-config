{ inputs, pkgs, settings, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "${settings.username}";
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "vim";
      HISTTIMEFORMAT = "%d/%m/%y %T "; # for cmd-wrapped to work
      HISTFILE = "/home/${settings.username}/.bash_history";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ ];
    historyFile = "/home/${settings.username}/.bash_history";
    historyFileSize = 100000;
    historyIgnore = [
      "sl"
    ];
    historySize = 100000;

    bashrcExtra = ''
      shopt -s histappend  # Append to the history file
      PROMPT_COMMAND="history -a; history -n; history -r; $PROMPT_COMMAND"
    '';
  };

  imports = [
    ./nvix.nix
  ];
}

