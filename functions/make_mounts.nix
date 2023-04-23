/*
  Make a mount tree for adding to `fileSystems`

*/
{ encryptedRootDeviceLabel, encryptedRootDevice, efiDevice }:

{
  "/" = {
    device = "/dev/mapper/${encryptedRootDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedRootDeviceLabel;
      blkDev = encryptedRootDevice;
    };
    options = [
      "subvol=root"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/home" = {
    device = "/dev/mapper/${encryptedRootDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedRootDeviceLabel;
      blkDev = encryptedRootDevice;
    };
    options = [
      "subvol=home"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/nix" = {
    device = "/dev/mapper/${encryptedRootDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedRootDeviceLabel;
      blkDev = encryptedRootDevice;
    };
    options = [
      "subvol=nix"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/persist" = {
    device = "/dev/mapper/${encryptedRootDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedRootDeviceLabel;
      blkDev = encryptedRootDevice;
    };
    neededForBoot = true;
    options = [
      "subvol=persist"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/boot" = {
    device = "/dev/mapper/${encryptedRootDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedRootDeviceLabel;
      blkDev = encryptedRootDevice;
    };
    neededForBoot = true;
    options = [
      "subvol=boot"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/var/log" = {
    device = "/dev/mapper/${encryptedRootDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedRootDeviceLabel;
      blkDev = encryptedRootDevice;
    };
    neededForBoot = true;
    options = [
      "subvol=log"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/efi" = {
    device = efiDevice;
    fsType = "vfat";
  };
}
