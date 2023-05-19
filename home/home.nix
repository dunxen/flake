{ config, pkgs, lib, ... }: {

  home.username = "dunxen";
  home.homeDirectory = "/home/dunxen";
  # home.sessionVariables.GTK_THEME = "palenight";

  programs.git = {
    enable = true;
    userName = "Duncan Dean";
    userEmail = "git@dunxen.dev";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs8y3pGOgEefYi6juRp+RECFq/uzYu7o3Qc6Wo0RD90 git@dunxen.dev";
      signByDefault = true;
    };
    aliases = {
      a = "add";
      b = "branch";
      c = "commit";
      ca = "commit --amend";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      dm = "diff --color-moved=plain";
      ds = "diff --staged";
      p = "push";
      pf = "push --force-with-lease";
      pl = "pull";
      l = "log";
      r = "rebase";
      s = "status --short";
      showm = "show --color-moved=plain";
      ss = "status";
      forgor = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      oops = "checkout --";
    };
    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];
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
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "pop-shell@system76.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
      favorite-apps = [ "firefox.desktop" "kitty.desktop" "org.gnome.Nautilus.desktop" "1password.desktop" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    # `gsettings get org.gnome.shell.extensions.user-theme name`
    # "org/gnome/shell/extensions/user-theme" = {
    #   name = "palenight";
    # };
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
    "org/gnome/shell/extensions/dash-to-dock" = {
      transparency-mode = "DYNAMIC";
    };
    "org/gnome/desktop/background" = {
      # picture-uri = "file://${./shapes.jpg}";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/dune-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/dune-d.svg";
      primary-color = "#f7a957";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/dune-d.svg";
      primary-color = "#f7a957";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 600;
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-scree = false;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 7200;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };
  };

  # Packages to have installed for this profile.
  home.packages = with pkgs; [
    age
    asn
    asnmap
    awscli2
    azure-cli
    bat
    bind
    bgpdump
    bundix
    carapace
    cloudflared
    cloudflare-warp
    cosign
    discord
    dnsx
    docker
    dogdns
    epiphany
    exercism
    fd
    firefox-wayland
    flyctl
    gcc12
    gh
    gimp
    git-crypt
    glow
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-dock
    gnomeExtensions.pop-shell
    go
    google-cloud-sdk
    htop
    inkscape
    julia
    keybase-gui
    neofetch
    nickel
    nixos-generators
    nls # Nickel Language Server
    obsidian
    protonmail-bridge
    protonvpn-cli
    protonvpn-gui
    riff
    ripgrep
    rustup
    signal-desktop
    stack
    starship
    steam
    subfinder
    tailscale
    termius
    telegram-desktop
    typst
    typst-lsp
    ungoogled-chromium
    wasmtime
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

  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
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
      {
        name = "nickel";
        indent = {
          tab-width = 2;
          unit = "\t";
        };
        scope = "source.nickel";
        injection-regex = "^ni?c(ke)?l$";
        file-types = ["ncl"];
        roots = [];
        comment-token = "#";
        language-server = {
          command = "nls";
        };
      }
    ];
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        color-modes = true;
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
