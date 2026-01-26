{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # Don't touch these partitions (Windows data, MSR, etc.):
            "reserved" = {
              start = "1s";
              end = "16MiB";
              type = "0c01";  # Microsoft Reserved
            };
            "windows" = {
              start = "16MiB";
              end   = "81GiB";
              type  = "0700";  # Windows partition (overlaps p2)
            };
            "recovery" = {
              start = "81GiB";
              end   = "81.8GiB";
              type  = "2700"; # Windows Recovery (p3)
            };
            # This is your existing EFI system
            ESP = {
              name = "EFI";
              start = "81.8GiB";
              end = "82.5GiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" "shortname=winnt" "nofail" ];
              };
            };
            # Now, swap, root, extra (Linux only):
            swap = {
              start = "82.5GiB";
              end = "86.02GiB";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            luksroot = {
              start = "86.02GiB";
              end = "228GiB";    # Adjust as you wish!
              content = {
                type = "luks";
                name = "cryptroot";
                settings = { allowDiscards = true; };
                initrdUnlock = true;
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "root" = { mountpoint = "/"; mountOptions = [ "compress=zstd" "noatime" ]; };
                    "home" = { mountpoint = "/home"; mountOptions = [ "compress=zstd" "noatime" ]; };
                    "nix" = { mountpoint = "/nix"; mountOptions = [ "compress=zstd" "noatime" ]; };
                    "persist" = { mountpoint = "/persist"; mountOptions = [ "compress=zstd" "noatime" ]; };
                    "log" = { mountpoint = "/var/log"; mountOptions = [ "compress=zstd" "noatime" ]; };
                    "snapshots" = { mountpoint = "/snapshots"; mountOptions = [ "compress=zstd" "noatime" ]; };
                  };
                  extraArgs = [ "-f" ];
                };
              };
            };
            # Don't touch "p5" and "p6" (you can add entries for them so Disko does not overwrite)
            win_data_1 = {
              start = "228.0GiB";
              end = "348.4GiB";
              type = "0700";
            };
            win_data_2 = {
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
