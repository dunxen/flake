{ config, pkgs, lib, ... }:

with lib.hm.gvariant;

let
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs8y3pGOgEefYi6juRp+RECFq/uzYu7o3Qc6Wo0RD90 git@dunxen.dev";
in
{
  imports = [
    ./programs
  ];

  home.username = "dunxen";
  home.homeDirectory = "/home/dunxen";
  home.file.".ssh/allowed_signers".text = "dunxen ${ssh_key}";

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts = [
      {
        timeout = 120;
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
      {
        timeout = 600;
        command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Duncan Dean";
        email = "git@dunxen.dev";
      };
    };
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;

  gtk = {
    enable = true;
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-icon-theme;
    # };
    # theme = {
    #   name = "palenight";
    #   package = pkgs.palenight-theme;
    # };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  dconf.settings = {
    "org/gnome/Console" = {
      theme = "auto";
    };
    # Desktop preferences
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${./wallpapers/greyguy.svg}";
      picture-uri-dark = "file://${./wallpapers/greyguy.svg}";
      primary-color = "#241f31";
      secondary-color = "#030f36";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/wallpapers/gnome/blobs-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };

    # Shell preferences
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "pop-shell@system76.com"
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
      favorite-apps = [ "firefox.desktop" "org.gnome.Nautilus.desktop" "1password.desktop" "Alacritty.desktop" "thunderbird.desktop" "obsidian.desktop" ];
    };
    # `gsettings get org.gnome.shell.extensions.user-theme name`
    # "org/gnome/shell/extensions/user-theme" = {
    #   name = "palenight";
    # };
    "org/gnome/shell/extensions/vitals" = {
      show-storage = false;
      show-voltage = true;
      show-memory = true;
      show-fan = true;
      show-temperature = true;
      show-processor = true;
      show-network = true;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      transparency-mode = "DYNAMIC";
    };
    "org/gnome/shell/extensions/pop-shell" = {
      gap-outer = mkUint32 8;
    };

    # Other preferences
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    # Keybindings
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Toggle Light/Dark Mode";
      binding = "<Shift><Super>d";
      command = "xterm -e bash /home/dunxen/.toggle-dark-mode.sh";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 7200;
    };
    "org/gnome/system/location" = {
      enabled = true;
    };
  };

  # Packages to have installed for this profile.
  home.packages =
    with pkgs; [
      age
      appimage-run
      asn
      asnmap
      bat
      beeper
      bgpdump
      bind
      blender-hip
      bun
      bundix
      calculix
      carapace
      comma
      cool-retro-term
      cosign
      devbox
      discord
      dnsx
      docker
      dogdns
      earthly
      element-desktop
      elmerfem
      epiphany
      esptool
      exercism
      fd
      firecracker
      firectl
      flyctl
      # See https://github.com/NixOS/nixpkgs/issues/263452
      # freecad
      gcc12
      gh
      gimp
      git-crypt
      git-nomad # Synchronise work-in-progress git branches in a light weight fashion
      gitoxide
      glow
      gmsh
      gnomeExtensions.appindicator
      gnomeExtensions.user-themes
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-dock
      gnomeExtensions.pop-shell
      go
      godot_4
      htop
      hydra-check
      inkscape
      jetbrains.rust-rover
      julia
      keybase-gui
      kubernetes-helm
      ledger
      ledger-live-desktop
      liana
      lldb
      llvm
      nickel
      nil # A nix language server
      nixos-generators
      nls # Nickel Language Server
      obsidian
      ookla-speedtest
      protonmail-bridge
      protonvpn-cli
      protonvpn-gui
      riff
      ripgrep
      rustup
      signal-desktop
      sparrow
      stack
      steam
      subfinder
      wl-clipboard
      mako
      rofi
      tailscale
      termius
      telegram-desktop
      thunderbird
      typst
      typst-lsp
      unixtools.xxd
      unzip
      usbutils
      vagrant
      vivaldi
      vivaldi-ffmpeg-codecs
      vlc
      wasmtime
      wally-cli
      wget
      zellij
      zola
      kicad
      obs-studio
      obs-studio-plugins.obs-gstreamer
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-multi-rtmp
      obs-studio-plugins.obs-move-transition
    ];

  programs.home-manager.enable = true;

  programs.himalaya = {
    enable = true;
  };

  home.stateVersion = "22.11";
}
