{ pkgs, settings, ... }:
{
  networking.hostName = settings.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

  # Enable networking
  networking.networkmanager.enable = true; 
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    2049 # for nfs
  ];
  networking.firewall.allowedUDPPorts = [  ];
  networking.firewall.enable = false;
  networking.firewall.checkReversePath = "loose";

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
  
  # networking.nftables.enable = true;
  services.resolved = {
    enable = false; # will break network, do not enable (works with services.nfs for some reason)
 };
  
  services.networkd-dispatcher = {
    enable = false;
    rules = {
      "enable-tailscale-settings" = {
        onState = ["routable"];
        script = ''
          #!/bin/sh
          IFACE="$(ip -o route get 8.8.8.8 | cut -f 5 -d ' ')"
          if [[ -n "$IFACE" ]]; then
            ethtool -K "$IFACE" rx-udp-gro-forwarding on rx-gro-list off
          fi
            exit 0
      '';
      };
    };
  };

}
