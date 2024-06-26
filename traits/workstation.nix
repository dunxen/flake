/*
  A trait for headed boxxen
*/
{ pkgs, ... }:

{
  config = {
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = with pkgs; [ amdvlk rocmPackages.clr.icd ];

    hardware.brillo.enable = true;

    xdg = {
      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
        # wlr.enable = true;
        config.common.default = "*";
      };
    };

    #hardware.steam-hardware.enable = true;
    #hardware.xpadneo.enable = true;

    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "full";
    };

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # These should only be GUI applications that are desired systemwide
    environment.variables = {
      # VDPAU_DRIVER = "radeonsi";
    };
    environment.systemPackages = with pkgs; [
      virt-manager
      openrgb
      libva-utils
      vdpauinfo
      ffmpeg
      openrgb
    ];

    services.udev = {
      packages = with pkgs; [ openrgb ];
      extraRules = ''
        # HW.1 / Nano
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c|2b7c|3b7c|4b7c", TAG+="uaccess", TAG+="udev-acl"
        # Blue
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000|0000|0001|0002|0003|0004|0005|0006|0007|0008|0009|000a|000b|000c|000d|000e|000f|0010|0011|0012|0013|0014|0015|0016|0017|0018|0019|001a|001b|001c|001d|001e|001f", TAG+="uaccess", TAG+="udev-acl"
        # Nano S
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001|1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|100a|100b|100c|100d|100e|100f|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|101a|101b|101c|101d|101e|101f", TAG+="uaccess", TAG+="udev-acl"
        # Aramis
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0002|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|200a|200b|200c|200d|200e|200f|2010|2011|2012|2013|2014|2015|2016|2017|2018|2019|201a|201b|201c|201d|201e|201f", TAG+="uaccess", TAG+="udev-acl"
        # HW2
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0003|3000|3001|3002|3003|3004|3005|3006|3007|3008|3009|300a|300b|300c|300d|300e|300f|3010|3011|3012|3013|3014|3015|3016|3017|3018|3019|301a|301b|301c|301d|301e|301f", TAG+="uaccess", TAG+="udev-acl"
        # Nano X
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004|4000|4001|4002|4003|4004|4005|4006|4007|4008|4009|400a|400b|400c|400d|400e|400f|4010|4011|4012|4013|4014|4015|4016|4017|4018|4019|401a|401b|401c|401d|401e|401f", TAG+="uaccess", TAG+="udev-acl"
        # Nano SP
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0005|5000|5001|5002|5003|5004|5005|5006|5007|5008|5009|500a|500b|500c|500d|500e|500f|5010|5011|5012|5013|5014|5015|5016|5017|5018|5019|501a|501b|501c|501d|501e|501f", TAG+="uaccess", TAG+="udev-acl"
        # Ledger Stax
        SUBSYSTEMS=="usb", GROUP="plugdev", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="6011", TAG+="uaccess", TAG+="udev-acl"
        # COLDCARD
        KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666"
        # FTDI USB
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="0666"
      '';
    };

    services.printing.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
