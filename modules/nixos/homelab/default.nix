{ config, lib, pkgs, ...}:

{
  config = {
    environment.systemPackages = with pkgs; [
      jellyfin
    ];

    fileSystems."/mnt/hdd" = {
      device = "/dev/disk/by-uuid/ccee5cb8-653c-4662-8fbd-40a1ae696465";
      fsType = "ext4";
    };

    programs.bash.shellAliases = {
      tsm = "transmission-remote";
    };

    services = {
      jellyfin = {
        enable = true;
        user = "dylan";
      };

      mullvad-vpn.enable = true;
      transmission = {
        enable = true; #Enable transmission daemon
        openRPCPort = true; #Open firewall for RPC
        settings = { #Override default settings
          download-dir = "/mnt/hdd/home/dylan/jellyfin_libraries/movies/";
          incomplete-dir = "/home/dylan/Downloads";
          rpc-bind-address = "0.0.0.0"; #Bind to own IP
          rpc-whitelist = "127.0.0.1,10.0.0.1"; #Whitelist your remote machine (10.0.0.1 in this example)
          script-torrent-done-enabled = true;
        };
      };
    };

    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}

