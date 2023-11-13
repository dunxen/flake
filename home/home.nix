{ pkgs, lib, ... }:

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

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "image/avif" = [ "oculante.desktop" ];
      "image/png" = [ "oculante.desktop" ];
      "image/webp" = [ "oculante.desktop" ];
      "image/jpeg" = [ "oculante.desktop" ];
      "image/svg" = [ "oculante.desktop" ];
      "image/gif" = [ "oculante.desktop" ];
      "image/tiff" = [ "oculante.desktop" ];
      "image/bmp" = [ "oculante.desktop" ];
      "application/x-ms-dos-executable" = [ "wine.desktop" ];
      "x-scheme-handler/mailto" = [ "userapp-Thunderbird-PA2251.desktop" ];
      "x-scheme-handler/mid" = [ "userapp-Thunderbird-PA2251.desktop" ];
    };
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "image/avif" = [ "oculante.desktop" ];
      "image/png" = [ "oculante.desktop" ];
      "image/webp" = [ "oculante.desktop" ];
      "image/jpeg" = [ "oculante.desktop" ];
      "image/svg+xml" = [ "oculante.desktop" ];
      "image/gif" = [ "oculante.desktop" ];
      "image/tiff" = [ "oculante.desktop" ];
      "image/bmp" = [ "oculante.desktop" ];
      "application/x-ms-dos-executable" = [ "wine.desktop" ];
      "x-scheme-handler/mailto" = [ "userapp-Thunderbird-PA2251.desktop" ];
      "message/rfc822" = [ "userapp-Thunderbird-PA2251.desktop" ];
      "x-scheme-handler/mid" = [ "userapp-Thunderbird-PA2251.desktop" ];
    };
  };
  xdg.desktopEntries = {
    oculante = {
      name = "Oculante";
      genericName = "Image viewer";
      exec = "oculante %U";
      terminal = false;
      mimeType = [
        "image/avif"
        "image/png"
        "image/webp"
        "image/jpeg"
        "image/svg"
        "image/bmp"
        "image/gif"
        "image/svg+xml"
        "image/tiff"
      ];
    };
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Yaru-magenta-dark";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "Tokyonight-Dark-B-LB";
      package = pkgs.tokyo-night-gtk;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };

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

  # Packages to have installed for this profile.
  home.packages =
    with pkgs;
    let
      spacedrive = pkgs.callPackage ../packages/spacedrive { };
      lume = pkgs.callPackage ../packages/lume { };
    in
    [
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
      evince
      exercism
      fd
      firecracker
      firectl
      flyctl
      freecad
      gcc12
      gh
      gimp
      git-crypt
      git-nomad # Synchronise work-in-progress git branches in a light weight fashion
      gitoxide
      glow
      gmsh
      go
      godot_4
      guix
      gum
      haskellPackages.epub-tools
      htop
      hydra-check
      inkscape
      jetbrains.rust-rover
      julia
      keybase-gui
      kicad
      kubernetes-helm
      ledger
      ledger-live-desktop
      liana
      lldb
      llvm
      lume
      mods
      neofetch
      nickel
      nil # A nix language server
      nixos-generators
      nls # Nickel Language Server
      obsidian
      obs-studio
      obs-studio-plugins.obs-gstreamer
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-multi-rtmp
      obs-studio-plugins.obs-move-transition
      oculante
      ookla-speedtest
      protonmail-bridge
      protonvpn-cli
      protonvpn-gui
      riff
      ripgrep
      rustup
      sage
      signal-desktop
      spacedrive
      sparrow
      stack
      steam
      subfinder
      tailscale
      termius
      telegram-desktop
      thunderbird
      typst
      typst-fmt
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
      wl-clipboard
      wofi
      zellij
      zola
    ];

  programs.home-manager.enable = true;

  programs.himalaya = {
    enable = true;
  };

  home.stateVersion = "22.11";
}
