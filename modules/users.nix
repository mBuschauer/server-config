{ pkgs, settings, secrets, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${settings.username} = {
    isNormalUser = true;
    description = "marco";
    extraGroups = [ "networkmanager" "wheel" "docker" "sharedFolder" "storage" ];
    packages = with pkgs; [
      lm_sensors # get temperature
      mprime # stress test 
    ];
    openssh.authorizedKeys.keys = secrets.opensshAuthorizedKeys;
  };

  users.users.michael = {
    isNormalUser = true;
    description = "for ssh";
    createHome = false;
    extraGroups = [ "networkmanager" "wheel" "docker" "sharedFolder" ];
    openssh.authorizedKeys.keys = [
    ];
  };

  programs.bash.shellAliases = {
    ls = "ls --color=never";
    edit-config = "cd /etc/nixos && sudo lvim";
    update-config = "sudo nixos-rebuild switch";
    upgrade-config = ''
      (
        original_dir=$(pwd)
        trap "cd $original_dir" EXIT INT TERM HUP

        cd /etc/nixos || exit 1
        sudo nix flake update
        sudo nixos-rebuild switch
      )
    '';
    disk-analysis = "sudo ncdu / --exclude=/mnt";
    neofetch = "fastfetch";
  };
}
