{ config, pkgs, lib, ... }:

with lib.hm.gvariant;

let
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs8y3pGOgEefYi6juRp+RECFq/uzYu7o3Qc6Wo0RD90 git@dunxen.dev";
in
{
  home.username = "dunxen";
  home.homeDirectory = "/home/dunxen";
  home.file.".ssh/allowed_signers".text = "dunxen ${ssh_key}";
  home.file.".toggle-dark-mode.sh".text = ''
    #!/bin/bash

    # Fail early, fail often.
    set -eu -o pipefail

    if gsettings get org.gnome.desktop.interface color-scheme | grep -q 'light'
    then
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
      sed -i 's/theme = ".*"/theme = "tokyonight_storm"/' /home/dunxen/.config/helix/config.toml
    else
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
      sed -i 's/theme = ".*"/theme = "nord_light"/' /home/dunxen/.config/helix/config.toml
    fi
  '';
  # home.sessionVariables.GTK_THEME = "palenight";

  programs.git = {
    enable = true;
    userName = "Duncan Dean";
    userEmail = "git@dunxen.dev";
    signing = {
      key = ssh_key;
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
    ignores = [ "*~" "*.swp" "*result*" ".direnv" "node_modules" ];
    lfs.enable = true;
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      diff.colormoved = "zebra";
      core.editor = "hx";
      gpg.format = "ssh";
      gpg.ssh.program = ''${pkgs._1password-gui}/share/1password/op-ssh-sign'';
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
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
      # picture-uri = "file://${./shapes.jpg}";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
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
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "de+neo" ]) ];
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
      ];
      favorite-apps = [ "firefox.desktop" "org.gnome.Nautilus.desktop" "1password.desktop" "Alacritty.desktop" "thunderbird.desktop" ];
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
    let
      liana = pkgs.callPackage ../packages/liana { };
    in
    with pkgs; [
      age
      appimage-run
      asn
      asnmap
      bat
      bind
      bgpdump
      bundix
      carapace
      comma
      cosign
      devbox
      direnv # Remove when programs.direnv is fixed.
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
      git-nomad # Synchronise work-in-progress git branches in a light weight fashion
      gitoxide
      glow
      gnomeExtensions.user-themes
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-dock
      gnomeExtensions.pop-shell
      go
      htop
      inkscape
      julia
      keybase-gui
      kubernetes-helm
      ledger
      ledger-live-desktop
      liana
      nickel
      nixos-generators
      nls # Nickel Language Server
      obsidian
      ookla-speedtest
      protonmail-bridge
      protonvpn-cli
      protonvpn-gui
      riff
      ripgrep
      ripgrep-all
      rustup
      signal-desktop
      sparrow
      stack
      starship # Remove when programs.starship is fixed.
      steam
      subfinder
      tailscale
      termius
      telegram-desktop
      thunderbird
      typst
      typst-lsp
      ungoogled-chromium
      unixtools.xxd
      unzip
      vagrant
      vlc
      wasmtime
      wget
      zellij
      zola
      zotero
      kicad
      obs-studio
      obs-studio-plugins.obs-gstreamer
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-multi-rtmp
      obs-studio-plugins.obs-move-transition
    ];

  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
    envFile.source = ./config/env.nu;
    configFile.source = ./config/config.nu;
  };

  # Disable because nushell v0.83.0 broke things
  # programs.starship = {
  #   enable = true;
  #   enableNushellIntegration = true;
  #   settings = {
  #     time = {
  #       disabled = false;
  #       time_format = "%T";
  #       utc_time_offset = "+2";
  #     };
  #   };
  # };

  # Disable because nushell v0.83.0 broke things
  # programs.atuin = {
  #   enable = true;
  #   flags = [ "--disable-up-arrow" ];
  #   enableNushellIntegration = true;
  # };

  # Disable because nushell v0.83.0 broke things
  # programs.direnv = {
  #   enable = true;
  #   enableNushellIntegration = true;
  # };

  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = {
        x = 8;
        y = 8;
      };
    };
  };

  programs.helix = {
    enable = true;
    languages = {
      language = [
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
          file-types = [ "typ" ];
          roots = [ ];
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
          file-types = [ "ncl" ];
          roots = [ ];
          comment-token = "#";
          language-server = {
            command = "nls";
          };
        }
      ];
    };
    settings = {
      theme = "tokyonight_storm";
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

  programs.himalaya = {
    enable = true;
  };

  home.stateVersion = "22.11";
}
