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

    gptfdisk
  ];

  services = {
    devmon.enable = true; # an automatic device mounting daemon
    gvfs.enable = true; # Git Virtual File System
    udisks2.enable = true;
    rpcbind.enable = true;
  };

  boot.swraid = {
    enable = true;
    mdadmConf = "
      PROGRAM ${pkgs.writeShellScript "save_to_log" ''
        echo \"$(date): $@\" >> /var/log/mdadm-events.log
      ''}
      ARRAY /dev/md/server-2025:0 metadata=1.2 spares=1 UUID=26ccd996:c70a2cb6:60bef53c:2e7ddf84
    ";
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

  fileSystems."/mnt/raid" = {
    device = "/dev/disk/by-uuid/0755c838-aaa3-458f-b716-2d535c5b6e52";
    fsType = "xfs";
    options = [
      "defaults"

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

      /mnt/raid          *(rw,nohide,insecure,no_subtree_check)
    '';
  };
}
