/*
  A trait for configurations which are most definitely machines
*/
{ pkgs, ... }:

{
  config = {
    boot.kernel.sysctl = {
      # TCP Fast Open (TFO)
      "net.ipv4.tcp_fastopen" = 3;
    };
    boot.initrd.availableKernelModules = [
      "usb_storage"
      "nbd"
      "nvme"
    ];
    boot.kernelModules = [
      "coretemp"
      "vfio-pci"
      "i2c-dev"
      "i2c-piix"
    ];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.efiSysMountPoint = "/efi";
    boot.binfmt.emulatedSystems = (if pkgs.stdenv.isx86_64 then [
      "aarch64-linux"
    ] else if pkgs.stdenv.isAarch64 then [
      "x86_64-linux"
    ] else [ ]);

    # http://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
    # security.pam.u2f.enable = true;
    # security.pam.u2f.cue = true;
    # security.pam.u2f.control = "optional";
    boot.initrd.systemd.enable = true;
    # boot.initrd.luks.fido2Support = true;
    boot.initrd.luks.mitigateDMAAttacks = true;

    # environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    environment.systemPackages = with pkgs; [
      i2c-tools
      libimobiledevice
      ifuse
      # qemu
    ];

    users.mutableUsers = false;

    powerManagement.cpuFreqGovernor = "ondemand";

    networking.networkmanager.enable = true;
    networking.wireless.enable = false; # For Network Manager
    networking.firewall.enable = true;
    networking.networkmanager.dns = "none";
    networking.nameservers = [ "127.0.0.1" "::1" ];
    services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        ipv4_servers = true;
        require_dnssec = true;
        doh_servers = true;
        odoh_servers = true;

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        sources.odoh-servers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
          ];
          cache_file = "odoh-servers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 24;
          prefix = "";
        };
        sources.odoh-relays = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
            "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
          ];
          cache_file = "odoh-relays.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 24;
          prefix = "";
        };
        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = [ "cloudflare" ];
      };
    };
    systemd.services.dnscrypt-proxy2.serviceConfig = {
      StateDirectory = "dnscrypt-proxy";
    };

    # For libvirt: https://releases.nixos.org/nix-dev/2016-January/019069.html
    networking.firewall.checkReversePath = false;

    programs.nm-applet.enable = true;

    programs.adb.enable = true;
    users.users.dunxen.extraGroups = [ "adbusers" ];

    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.tailscale = {
      enable = true;
      extraUpFlags = [ "--operator dunxen" ];
    };
    systemd.user.services.tailreceive = {
      enable = true;
      description = "File Receiver Service for Taildrop";
      serviceConfig = {
        Type = "simple";
        ExecStart = "/etc/profiles/per-user/dunxen/bin/tailscale file get --verbose --conflict=overwrite --loop /home/dunxen/taildrops";
      };
      wantedBy = [ "default.target" ];
    };
    systemd.user.services.atuind = {
      enable = true;

      environment = {
        ATUIN_LOG = "info";
      };
      serviceConfig = {
        ExecStart = "/etc/profiles/per-user/dunxen/bin/atuin daemon";
      };
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
    };
    services.tor.enable = true;
    services.flatpak.enable = true;

    security.rtkit.enable = true;
    security.polkit.enable = true;
    # Allow hyprlock to unlock the computer for us
    security.pam.services.hyprlock = {
      text = "auth include login";
    };

    hardware.pulseaudio.enable = false;
    hardware.i2c.enable = true;
    hardware.hackrf.enable = true;
    hardware.rtl-sdr.enable = true;
    hardware.flipperzero.enable = true;
    hardware.bluetooth.enable = true;
    hardware.xpadneo.enable = true; # For Xbox One Controller
    hardware.keyboard.zsa.enable = true;

    # virtualisation.libvirtd.enable = true;
    # virtualisation.libvirtd.onBoot = "ignore";
    # virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
    # virtualisation.libvirtd.qemu.ovmf.enable = true;
    # virtualisation.libvirtd.qemu.ovmf.packages = if pkgs.stdenv.isx86_64 then [ pkgs.OVMFFull.fd ] else [ pkgs.OVMF.fd ];
    # virtualisation.libvirtd.qemu.swtpm.enable = true;
    # virtualisation.libvirtd.qemu.swtpm.package = pkgs.swtpm;
    # virtualisation.libvirtd.qemu.runAsRoot = false;
    # virtualisation.virtualbox.host.enable = true;
    # virtualisation.spiceUSBRedirection.enable = true; # Note that this allows users arbitrary access to USB devices. 
    # virtualisation.podman.enable = true;

    # For iOS devices. Currently broken
    # services.usbmuxd.enable = true;

    # opt in state
    # From https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
    environment.etc = {
      nixos.source = "/persist/etc/nixos";
      "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
      adjtime.source = "/persist/etc/adjtime";
      # NIXOS.source = "/persist/etc/NIXOS";
      machine-id.source = "/persist/etc/machine-id";
      "vbox/networks.conf".text = ''
        * 10.0.0.0/8 192.168.0.0/16
        * 2001::/64
      '';
    };
    systemd.tmpfiles.rules = [
      "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
      "L /etc/secrets - - - - /persist/secrets"
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      #"L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    ];
    # boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    #   mkdir -p /mnt

    #   # We first mount the btrfs root to /mnt
    #   # so we can manipulate btrfs subvolumes.
    #   mount -o subvol=/ /dev/mapper/encrypt /mnt

    #   # While we're tempted to just delete /root and create
    #   # a new snapshot from /root-blank, /root is already
    #   # populated at this point with a number of subvolumes,
    #   # which makes `btrfs subvolume delete` fail.
    #   # So, we remove them first.
    #   #
    #   # /root contains subvolumes:
    #   # - /root/var/lib/portables
    #   # - /root/var/lib/machines
    #   #
    #   # I suspect these are related to systemd-nspawn, but
    #   # since I don't use it I'm not 100% sure.
    #   # Anyhow, deleting these subvolumes hasn't resulted
    #   # in any issues so far, except for fairly
    #   # benign-looking errors from systemd-tmpfiles.

    #   btrfs subvolume list -o /mnt/root |
    #   cut -f9 -d' ' |
    #   while read subvolume; do
    #     echo "deleting /$subvolume subvolume..."
    #     btrfs subvolume delete "/mnt/$subvolume"
    #   done &&
    #   echo "deleting /root subvolume..." &&
    #   btrfs subvolume delete /mnt/root

    #   echo "restoring blank /root subvolume..."
    #   btrfs subvolume snapshot /mnt/snapshots/root/blank /mnt/root

    #   # Once we're done rolling back to a blank snapshot,
    #   # we can unmount /mnt and continue on the boot process.
    #   umount /mnt
    # '';
    swapDevices = [ ];
  };
}
