{ config, pkgs, lib, ... }: {

  home.username = "dunxen";
  home.homeDirectory = "/home/dunxen";
  home.sessionVariables.GTK_THEME = "palenight";

  programs.git = {
    enable = true;
    userName = "Duncan Dean";
    userEmail = "duncangleeddean@gmail.com";
    signing = {
      key = "C37B1C1D44C786EE";
      signByDefault = true;
    };
    aliases = {
      dm = "diff --color-moved=plain";
      showm = "show --color-moved=plain";
      ds = "diff --staged";
      lgod = "log --graph --oneline --decorate";
      gb = "git branch";
    };
    lfs.enable = true;
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      diff.colormoved = "zebra";
      core.editor = "hx";
    };
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
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

  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
        "dash-to-panel@jderose9.github.com"
        "space-bar@luchrioh"
      ];
      favorite-apps = [ "firefox.desktop" "kitty.desktop" "org.gnome.Nautilus.desktop" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    # `gsettings get org.gnome.shell.extensions.user-theme name`
    "org/gnome/shell/extensions/user-theme" = {
      name = "palenight";
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell/extensions/vitals" = {
      show-storage = false;
      show-voltage = true;
      show-memory = true;
      show-fan = true;
      show-temperature = true;
      show-processor = true;
      show-network = true;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${./shapes.jpg}";
      picture-uri-dark = "file://${./shapes.jpg}";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${./shapes.jpg}";
      primary-color = "#3465a4";
      secondary-color = "#000000";
    };
  };

  # Packages to have installed for this profile.
  home.packages = with pkgs; [
    _1password-gui
    age
    bat
    cloudflared
    cloudflare-warp
    discord
    docker
    fd
    firefox
    gh
    gimp
    git-crypt
    glow
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.space-bar
    helix
    htop
    inkscape
    nixos-generators
    obsidian
    protonmail-bridge
    riff
    ripgrep
    rustup
    signal-desktop
    starship
    steam
    tailscale
    thunderbird
    telegram-desktop
    wireshark
    zotero
  ]  ++ (if stdenv.isx86_64 then [
    kicad
    chromium
    obs-studio
    obs-studio-plugins.obs-gstreamer
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-pipewire-audio-capture
    obs-studio-plugins.obs-multi-rtmp
    obs-studio-plugins.obs-move-transition
  ] else if stdenv.isAarch64 then [  ] else [  ]);

  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
    # envFile = builtins.readFile ./config/env.nu;
    # configFile = builtins.readFile ./config/config.nu;
  };

  programs.kitty = {
    enable = true;
    # extraConfig = builtins.readFile ./config/kitty.conf;
  };

  home.stateVersion = "22.11";
}
