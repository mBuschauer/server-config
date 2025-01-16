{ ... }:
{
services.cron = {
    enable = true;
    systemCronJobs = [
      "0 4 * * 1 rsync -av /mnt/raid/Calibre/ /home/marco/Calibre/"
    ];
  };
}
