{ pkgs, secrets, settings, ... }:
{

  boot.initrd = {
    supportedFilesystems = [ 
      "nfs" 
      "dm-raid" # fixes `raid1: Required device-mapper target(s) not detected in your kernel.`
      "dm-cache" # fixes `cache-pool: Required device-mapper target(s) not detected in your kernel.`
      "dm_cache_mq" # Enables multiqueue support for better performance in LVM caching.
      "dm_persistent_data" # Supports the persistent metadata used in the cache.
      "dm_mod" # General device mapper module required for LVM.
    ];
    kernelModules = [ 
      "nfs" 
      "dm-raid" # fixes `raid1: Required device-mapper target(s) not detected in your kernel.`
      "dm-cache" # fixes `cache-pool: Required device-mapper target(s) not detected in your kernel.` 
      "dm_cache_mq" # Enables multiqueue support for better performance in LVM caching.
      "dm_persistent_data" # Supports the persistent metadata used in the cache.
      "dm_mod" # General device mapper module required for LVM.
 ];
  };

  environment.systemPackages = with pkgs; [
    ntfs3g
    mdadm # for managing RAID arrays in Linux

    udiskie # for automatic mounting of USB drives

    jmtpfs # for FTP with android phones

    nfs-utils # for mounting nfs drive

    xfsprogs # for xfs support

    bcache-tools # for ssd caching

    sysstat

    smartmontools

    gptfdisk
    parted
  ];

  services = {
    devmon.enable = true; # an automatic device mounting daemon
    gvfs.enable = true; # Git Virtual File System
    udisks2.enable = true;
    rpcbind.enable = true;
    lvm = {
      enable = true;
      boot.thin.enable =  true;
      dmeventd.enable = true;
    };
    smartd = {
      enable = true;
      autodetect = true;
    };
    samba = {
      enable = false;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "server-2025";
          "netbios name" = "server-2025";
          "security" = "user";
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "marcoStorage" = {
          "path" = "/mnt/raid";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "${settings.username}";
          "force group" = "users";
        };
      };
    };
    samba-wsdd = {
      enable = false;
      openFirewall = true;
    };
  };

  boot.swraid = {
    enable = true;
    mdadmConf = "
      PROGRAM ${pkgs.writeShellScript "save_to_log" ''
        echo \"$(date): $@\" >> /var/log/mdadm-events.log
      ''}
    ";
    #  ARRAY /dev/md/server-2025:0 metadata=1.2 spares=1 UUID=26ccd996:c70a2cb6:60bef53c:2e7ddf84
    #";
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

  #fileSystems."/mnt/raid" = {
  #  device = "/dev/disk/by-uuid/0755c838-aaa3-458f-b716-2d535c5b6e52";
  #  fsType = "xfs";
  #  options = [
  #    "defaults"
  #    "nofail"
  #    "users"
  #    # "x-systemd.requires=mdadm-last-resort@md127.service"
  #  ];
  #};

  #fileSystems."/export/raid" = {
  #  device = "/mnt/raid";
  #  options = [ "bind" "nofail" ];
  #};

  #services.nfs.server = {
  #  enable = true;
  #  exports = ''
  #    /export            *(rw,fsid=0,no_subtree_check)
  #    /export/raid       *(rw,nohide,insecure,no_subtree_check)
  #  '';
  #};
}
