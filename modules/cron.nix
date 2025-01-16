{ ... }:
{
{
  systemd.timers."rsync-weekly" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon 04:00";  # Every Monday at 4:00 AM
      Persistent = true;         # Ensure the timer runs if the system was off
    };
  };

  systemd.services."rsync-weekly" = {
    script = ''
      set -eu
      /run/current-system/sw/bin/rsync -av /mnt/raid/Calibre/ /home/marco/Calibre/
    '';
    serviceConfig = {
      Type = "oneshot";          # Run the service once per activation
      # User = "root";             # Run as root (adjust if needed)
    };
  };
}

services.cron = {
    enable = false;
    systemCronJobs = [
      "0 4 * * 1 rsync -av /mnt/raid/Calibre/ /home/marco/Calibre/"
    ];
  };
}
