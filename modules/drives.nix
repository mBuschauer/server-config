{ pkgs, secrets, settings, ... }:
{

  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  environment.systemPackages = with pkgs; [
    ntfs3g
    mdadm # for managing RAID arrays in Linux
    lvm2 # for LVM support

    udiskie # for automatic mounting of USB drives

    jmtpfs # for FTP with android phones

    nfs-utils # for mounting nfs drive

    xfsprogs # for xfs support

    bcache-tools # for ssd caching

    sysstat

    smartmontools
  ];

  services = {
    devmon.enable = true; # an automatic device mounting daemon
    gvfs.enable = true; # Git Virtual File System
    udisks2.enable = true;
  };

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


  #fileSystems."/export/Calibre" = {
  #  device = "/home/${settings.username}/Calibre";
  #  options = [ "bind" ];
  #};


  #services.nfs.server = {
  #  enable = true;
  #  exports = ''
  #    /export            *(rw,fsid=0,no_subtree_check)
  #    /export/Calibre    *(rw,nohide,insecure,no_subtree_check)
  #  '';
  #};
}
