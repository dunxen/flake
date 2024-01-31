# dunxen's Nix Flake ❄️

This is a flake heavily borrowed from and inspired by [hoverbear's flake](https://github.com/Hoverbear-Consulting/flake).

# Packages

TODO: Add custom packages here.

# NixOS Configurations

General dogma:

* Only UEFI, with a 512MB+ FAT32 partition on the `/boot` block device.
* BTRFS based root block devices (in a `dm-crypt`).
* Firewalled except port 22.
* Preconfigured, ready to use, global (`helix`) editor and shell (`nushell`) configuration.
* Somewhat hardened hardware nodes.
* Relaxed user access control.
* Nix features `nix-command` and `flake` adopted.

## Partitioning

The machines share a common partitioning strategy, once setting the required environment variables, a script assists:

> **WARNING!:** This script will **destroy** any disks and partitions you point it at, and is not designed for uncareful use.
>
> Be careful! Please!

```shell
sudo nix run git+ssh://git.dunxen.dev/flake#unsafe-bootstrap
```

## Post-install

After install, set the password for `dunxen`:

```shell
nix run nixpkgs#mkpasswd -- --stdin --method=sha-512 > /mnt/persist/encrypted-passwords/dunxen
```

### Yubikeys

For Yubikeys, use U2F:

```shell
mkdir -p $HOME/.config/Yubico/
pamu2fcfg >> $HOME/.config/Yubico/u2f_keys
```

For more keys, just do the same thing.

To use these keys on the `dm-crypt`:

```shell
systemd-cryptenroll --fido2-device=auto $ROOT_PARTITION
```

## Brute

An x86_64 workstation.

* [16 core Ryzen 9][chips-amd5950x] in an [X370][parts-msi-x370]
* 4x 32 GB, 3600 Mhz RAM
* 1 TB M.2 NVMe - Mushkin
* 2x 1 TB SATA SSDs - Mushkin
* 2 TB SATA HDD - WD
* XFX Speedster SWFT 309 Radeon RX 6700 10GB GDDR6 HDMI 3xDP, AMD RDNA 2

## Preparation

Requires:

* An `x86_64-linux` based `nix`.
* A USB stick, 8+ GB preferred. ([Ex][parts-usb-stick-ex])

Build a recovery image:

```shell
nix build git+ssh://git.dunxen.dev/flake#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage
```

Flash it to a USB:

```shell
BRUTE_USB=/dev/null
umount $BRUTE_USB
sudo cp -vi isoImage/iso/*.iso $BRUTE_USB
```

## Bootstrap

Start the machine, or reboot it. Once logged in, partion, format, and mount the NVMe disk:

```shell
export TARGET_DEVICE=/dev/nvme1n1
export EFI_PARTITION=/dev/nvme1n1p1
export ROOT_PARTITION=/dev/nvme1n1p2
```

Then, **follow the [Partitioning](#partitioning) section.**

After, install the system:

```shell
sudo bootctl install --esp-path=/mnt/efi
sudo nixos-install --flake git+ssh://git.dunxen.dev/flake#brute --impure
```

## Neon

An x86_64 laptop.

* [WootBook Metal 15-PF5NU1G-4600H][machines-wootbook-15]
  * 500 GB M.2 NVMe - Mushkin
  * 16 GB RAM

## Preparation

Requires:

* An `x86_64-linux` based `nix`.
* A USB stick, 8+ GB preferred. ([Ex][parts-usb-stick-ex])

Build a recovery image:

```shell
nix build git+ssh://git.dunxen.dev/flake#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage
```

Flash it to a USB:

```shell
NEON_USB=/dev/null
umount $NEON_USB
sudo cp -vi isoImage/iso/*.iso $NEON_USB
```

## Bootstrap


Start the machine, or reboot it. Once logged in, partion, format, and mount the NVMe disk:

```shell
export TARGET_DEVICE=/dev/nvme0n1
export EFI_PARTITION=/dev/nvme0n1p1
export ROOT_PARTITION=/dev/nvme0n1p2
```

Then, **follow the [Partitioning](#partitioning) section.**

After, install the system:

```shell
sudo bootctl install --esp-path=/mnt/efi
sudo nixos-install --flake git+ssh://git.dunxen.dev/flake#neon --impure
```

[chips-amd5950x]: https://en.wikichip.org/wiki/amd/ryzen_9/5950x
[parts-msi-x370]: https://www.msi.com/Motherboard/X370-GAMING-PRO-CARBON/Specification
[machines-wootbook-15]: https://www.wootware.co.za/wootbook-metal-15-pf5nu1g-4600h-amd-ryzen-5-4600h-3-0ghz-hex-core-15-6-full-hd-1920x1080-ips-space-black-notebook.html#product_tabs_description_tabbed
