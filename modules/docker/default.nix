{ pkgs, ... }:
{
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker;
    liveRestore = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "docker";

  imports = [

  ];


}
