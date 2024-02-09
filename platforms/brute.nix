{ config, pkgs, lib, modulesPath, ... }:

let
  encryptedDeviceLabel = "encrypt";
  encryptedDevice = "/dev/nvme0n1p2";
  efiDevice = "/dev/nvme0n1p1";
  makeMounts = import ./../functions/make_mounts.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  config = {
    boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "iommu=1" "rd.driver.pre=vfio-pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "tap" "kvm-amd" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

    services.openssh.enable = false;

    hardware.cpu.amd.updateMicrocode = true;

    fileSystems = lib.mergeAttrs
      (makeMounts {
        inherit encryptedDevice encryptedDeviceLabel efiDevice;
      })
      {
        "/mnt/HDD1" = {
          device = "/dev/disk/by-uuid/33d3d934-87c5-4598-8cdf-3fdcce19e6c7";
          fsType = "btrfs";
        };

        "/mnt/SSD1" = {
          device = "/dev/disk/by-uuid/37306caf-1bb1-4103-983a-2a47cbe8e7f8";
          fsType = "btrfs";
        };

        "/mnt/SSD2" = {
          device = "/dev/disk/by-uuid/eaec9e9d-c7a4-4fbf-a16d-6a4182b2fb77";
          fsType = "btrfs";
        };
      };

    boot.initrd.luks.devices = {
      "luks-1238aac3-0daa-42cc-be43-2ae27bf4a824" = {
        device = "/dev/disk/by-uuid/1238aac3-0daa-42cc-be43-2ae27bf4a824";
        preLVM = true;
        allowDiscards = true;
      };

      "luks-dbce0bd4-1023-4d80-ab04-de307b30bc34" = {
        device = "/dev/disk/by-uuid/dbce0bd4-1023-4d80-ab04-de307b30bc34";
        preLVM = true;
        allowDiscards = true;
      };

      "luks-94ac69ed-8b63-482e-afd2-ced79beb64b2" = {
        device = "/dev/disk/by-uuid/94ac69ed-8b63-482e-afd2-ced79beb64b2";
        preLVM = true;
        allowDiscards = true;
      };
    };

    # This doesn't seem to work...
    /* environment.etc."crypttab" = {
      enable = true;
      text = ''
      encrypt /dev/nvme1n1p2 - fido2-device=auto
      '';
    }; */

    virtualisation.docker.enable = true;

    nix.distributedBuilds = true;
    nix.settings.builders = [ "@/etc/nix/machines" ];

    networking.hostName = "brute";
    networking.domain = "taproot.home";
  };
}
