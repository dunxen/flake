{ config, pkgs, lib, ... }: {

  home.username = "dunxen";
  home.homeDirectory = "/home/dunxen";
  home.sessionVariables.GTK_THEME = "palenight";

  programs.git = {
    enable = true;
    userName = "Duncan Dean";
    userEmail = "git@dunxen.dev";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs8y3pGOgEefYi6juRp+RECFq/uzYu7o3Qc6Wo0RD90 git@dunxen.dev";
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
      gpg.format = "ssh";
      gpg.ssh.program = ''${pkgs._1password-gui}/share/1password/op-ssh-sign'';
    };
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
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
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
  };

  # Packages to have installed for this profile.
  home.packages = with pkgs; [
    age
    awscli2
    azure-cli
    bat
    bundix
    cloudflared
    cloudflare-warp
    cosign
    discord
    docker
    epiphany
    exercism
    fd
    firefox
    flyctl
    gcc12
    gh
    gimp
    git-crypt
    glow
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.space-bar
    go
    google-cloud-sdk
    htop
    inkscape
    julia
    keybase-gui
    neofetch
    nixos-generators
    obsidian
    protonmail-bridge
    riff
    ripgrep
    rustup
    rust-analyzer
    signal-desktop
    stack
    starship
    steam
    tailscale
    termius
    telegram-desktop
    typst
    typst-lsp
    ungoogled-chromium
    wasmtime
    wireshark
    zellij
    zola
    zotero
  ]  ++ (if stdenv.isx86_64 then [
    kicad
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
    envFile.source = ./config/env.nu;
    configFile.source = ./config/config.nu;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.helix = {
    enable = true;
    languages = [
      {
        name = "rust";
        indent = {
          tab-width = 4;
          unit = "\t";
        };
      }
      {
        name = "typst";
        scope = "source.typst";
        injection-regex = "^typ(st)?$";
        file-types = ["typ"];
        roots = [];
        comment-token = "//";
        language-server = {
          command = "typst-lsp";
        };
        config = {
          exportPdf = "onType";
        };
      }
    ];
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "¦";
          skip-levels = 1;
        };
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            newline = "none";
          };
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };
        file-picker.hidden = false;
      };
    };
  };

  programs.kitty = {
    enable = true;
    theme = "GitHub Dark";
    font.name = "JetBrains Mono Nerd Font";
    font.size = 14.0;
    settings = {
      background_opacity = "0.95";
      window_padding_width = 6;
    };
  };

  programs.himalaya = {
    enable = true;
  };

  home.stateVersion = "22.11";
}
