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
  ];

  config = {
    boot.kernelModules = [ "kvm-amd" ];
    fileSystems = makeMounts {
      inherit encryptedDevice encryptedDeviceLabel efiDevice;
    };

    service.openssh.enable = false;
    networking.hostName = "neon";
    networking.domain = "taproot.home";
  };
}
