{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # --- Windows and Reserved Partitions: DO NOT TOUCH! ---
            "msr" = {
              start = "1s";
              end = "16MiB";
              type = "0c01"; # Microsoft Reserved
            };
            "win-main" = {
              start = "16MiB";
              end   = "81GiB";
              type  = "0700"; # Windows main OS
            };
            "win-recovery" = {
              start = "81GiB";
              end   = "81.8GiB";
              type  = "2700"; # Windows Recovery
            };
            # --- EFI Partition: MOUNT ONLY, DO NOT FORMAT! ---
            ESP = {
              name = "EFI";
              start = "81.8GiB";
              end = "82.5GiB";
              type = "EF00";
              content = {
                type = "filesystem";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" "shortname=winnt" "nofail" ];
                # NO `format = ...` = do not reformat, just mount.
              };
            };
            # --- Linux Swap Partition: 3.52 GiB ---
            swap = {
              start = "82.5GiB";
              end = "86.02GiB";
              content = {
                type = "swap";
                resumeDevice = true; # for hibernation support, optional
              };
            };
            # --- Linux root: LUKS, BTRFS with subvols for impermanence/hyprland ---
            root = {
              start = "86.02GiB";
              end = "228GiB";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = { allowDiscards = true; };
                initrdUnlock = true;
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "root" = { mountpoint = "/";      mountOptions = [ "compress=zstd" "noatime" ]; };
                    "home" = { mountpoint = "/home";  mountOptions = [ "compress=zstd" "noatime" ]; };
                    "nix"  = { mountpoint = "/nix";   mountOptions = [ "compress=zstd" "noatime" ]; };
                    "persist" = { mountpoint = "/persist"; mountOptions = [ "compress=zstd" "noatime" ]; };
                    "log"     = { mountpoint = "/var/log"; mountOptions = [ "compress=zstd" "noatime" ]; };
                    "snapshots" = { mountpoint = "/snapshots"; mountOptions = [ "compress=zstd" "noatime" ]; };
                  };
                  extraArgs = [ "-f" ];
                };
              };
            };
            # --- Windows Data Partitions: DO NOT TOUCH! ---
            win-data-1 = {
              start = "228GiB";
              end = "348.4GiB";
              type = "0700";
            };
            win-data-2 = {
              start = "348.4GiB";
              end   = "476.9GiB";
              type  = "0700";
            };
          };
        };
      };
    };
  };
}
