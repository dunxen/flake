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
      name = "Dracula";
      package = pkgs.dracula-theme;
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
      lume = pkgs.callPackage ../packages/lume { };
    in
    [
      age
      appimage-run
      asn
      asnmap
      bat
      bcachefs-tools
      beeper
      bgpdump
      bind
      blender-hip
      blueman
      bottom
      brave
      bun
      bundix
      calculix
      carapace
      cloudflared
      comma
      cool-retro-term
      cosign
      cosmic-edit
      cosmic-files
      cosmic-randr
      cosmic-term
      cura
      deno
      devbox
      discord
      dnsx
      docker
      dogdns
      dua
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
      flashprint
      flyctl
      freecad
      gcc12
      gh
      gimp
      git-absorb
      git-crypt
      git-nomad # Synchronise work-in-progress git branches in a light weight fashion
      gitoxide
      glow
      glxinfo
      gmsh
      gnome.nautilus
      gnuplot
      gnuradio
      go
      godot_4
      grim
      guix
      gum
      # broken
      # haskellPackages.epub-tools
      heaptrack
      htop
      hydra-check
      hyprshot
      imhex
      inkscape
      jetbrains.rust-rover
      julia
      keybase-gui
      keymapp
      kicad
      kubernetes-helm
      ledger
      ledger-live-desktop
      liana
      lld
      lldb
      llvm
      lume
      mars-mips
      melt
      mods
      mold
      neofetch
      nickel
      nil # A nix language server
      nixos-generators
      nixpkgs-review
      nls # Nickel Language Server
      nodePackages.prettier
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server
      obsidian
      obs-studio
      obs-studio-plugins.obs-gstreamer
      obs-studio-plugins.obs-move-transition
      obs-studio-plugins.obs-multi-rtmp
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-vkcapture
      oculante
      ookla-speedtest
      opendrop
      openrocket
      owl
      paraview
      pavucontrol
      postman
      protonmail-desktop
      protonvpn-cli
      protonvpn-gui
      rars
      # riff # discontinued 😔
      ripgrep
      rustup
      # broken again
      # sage
      scilab-bin
      semgrep
      semgrep-core
      serial-studio
      signal-desktop
      simplex-chat-desktop
      slack
      slurp
      spacedrive
      sparrow
      stack
      steam
      subfinder
      tailscale
      tailwindcss-language-server
      telegram-desktop
      termius
      thunderbird
      typst
      typst-fmt
      typst-lsp
      unixtools.xxd
      unzip
      usbutils
      vagrant
      vlc
      vscode
      vscode-langservers-extracted
      vulkan-tools
      wabt
      wally-cli
      # Disable until there is nushell support
      # warp-terminal
      wasmtime
      wgcf
      wget
      wl-clipboard
      wofi
      wrangler
      zola
    ];

  programs.home-manager.enable = true;

  programs.himalaya = {
    enable = true;
  };

  home.stateVersion = "22.11";
}
