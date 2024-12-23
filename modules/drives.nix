{ pkgs, secrets, settings, ... }:
{

  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  fileSystems."/mnt/Videos" = {
    device = "//${secrets.nasIP}/Videos";
    fsType = "cifs";
    options = [
      "x-systemd.automount"

      "username=${secrets.nasUser}"
      "password=${secrets.nasPassword}"
      
      "uid=1000"
      "users"
    ];
  };

  fileSystems."/mnt/Documents" = {
    device = "//${secrets.nasIP}/Documents";
    fsType = "cifs";
    options = [
      "x-systemd.automount"

      "username=${secrets.nasUser}"
      "password=${secrets.nasPassword}"
      
      "uid=1000"
      "users"
    ];
  };


  fileSystems."/export/Calibre" = {
    device = "/home/${settings.username}/Calibre";
    options = [ "bind" ];
  };


  services.nfs.server = {
    enable = true;
    exports = ''
      /export            *(rw,fsid=0,no_subtree_check)
      /export/Calibre    *(rw,nohide,insecure,no_subtree_check)
    '';
  };
}
