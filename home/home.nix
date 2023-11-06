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
      go
      godot_4
      guix
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
      ookla-speedtest
      protonmail-bridge
      protonvpn-cli
      protonvpn-gui
      riff
      ripgrep
      rofi
      rustup
      signal-desktop
      sparrow
      stack
      steam
      subfinder
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
      wl-clipboard
      zellij
      zola
    ];

  programs.home-manager.enable = true;

  programs.himalaya = {
    enable = true;
  };

  home.stateVersion = "22.11";
}
