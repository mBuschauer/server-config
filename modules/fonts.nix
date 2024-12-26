{ pkgs, settings, ... }:
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      font-awesome
      ibm-plex
      corefonts

      nerd-fonts.space-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.dejavu-sans-mono
    ];
  };

}

