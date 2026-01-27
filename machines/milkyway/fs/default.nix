{
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/c2e64ae3-330d-44de-a74c-49af559f2e6a";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4711f585-c4a4-4c27-970e-f918576285fb";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/AE4A-6B9A";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/4711f585-c4a4-4c27-970e-f918576285fb";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/4711f585-c4a4-4c27-970e-f918576285fb";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=persist" "compress=zstd" "noatime"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/4711f585-c4a4-4c27-970e-f918576285fb";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=log" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/4711f585-c4a4-4c27-970e-f918576285fb";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };

    "/snapshots" = {
      device = "/dev/disk/by-uuid/4711f585-c4a4-4c27-970e-f918576285fb";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=snapshots" "compress=zstd" "noatime"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/3c35c12b-ccf7-45dd-b57e-406a66975ecb";}
  ];
}
