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
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "us+colemak" ]) ];
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
      bgpdump
      bind
      blender-hip
      bundix
      carapace
      comma
      cosign
      devbox
      discord
      dnsx
      docker
      dogdns
      epiphany
      exercism
      fd
      firecracker
      firectl
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
      hydra-check
      inkscape
      julia
      keybase-gui
      kubernetes-helm
      ledger
      ledger-live-desktop
      liana
      lldb
      llvm
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
      vagrant
      vivaldi
      vivaldi-ffmpeg-codecs
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

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      time = {
        disabled = false;
        time_format = "%T";
        utc_time_offset = "+2";
      };
    };
  };

  programs.atuin = {
    enable = true;
    # flags = [ "--disable-up-arrow" ];
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

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

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;

    profiles.dunxen = {
      name = "default";
      isDefault = true;
      id = 0;
      path = "s17wnvo1.default";

      settings = {
        # Minimally adapted from arkenfox
        # https://github.com/arkenfox/user.js/blob/master/user.js
        "browser.aboutConfig.showWarning" = false;

        /*** [SECTION 0100]: STARTUP ***/
        "browser.startup.page" = 3;
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false; # [FF58+] Pocket > Sponsored Stories
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false; # [FF83+] Sponsored shortcuts
        "browser.newtabpage.activity-stream.default.sites" = "";

        /*** [SECTION 0200]: GEOLOCATION / LANGUAGE / LOCALE ***/
        /* 0201: use Mozilla geolocation service instead of Google if permission is granted [FF74+]
         * Optionally enable logging to the console (defaults to false) ***/
        "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.network.logging.enabled" = true; # [HIDDEN PREF]
        /* 0202: disable using the OS's geolocation service ***/
        "geo.provider.use_corelocation" = false; # [MAC]
        "geo.provider.use_gpsd" = false; # [LINUX]
        "geo.provider.use_geoclue" = false; # [FF102+] [LINUX]
        /* 0210: set preferred language for displaying pages
         * [SETTING] General>Language and Appearance>Language>Choose your preferred language...
         * [TEST] https://addons.mozilla.org/about ***/
        "intl.accept_languages" = "en-za, en-us, en";
        /* 0211: use en-US locale regardless of the system or region locale
         * [SETUP-WEB] May break some input methods e.g xim/ibus for CJK languages [1]
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=867501,1629630 ***/
        "javascript.use_us_english_locale" = true; # [HIDDEN PREF]

        /*** [SECTION 0300]: QUIETER FOX ***/
        /** RECOMMENDATIONS ***/
        /* 0320: disable recommendation pane in about:addons (uses Google Analytics) ***/
        "extensions.getAddons.showPane" = false; # [HIDDEN PREF]
        /* 0321: disable recommendations in about:addons' Extensions and Themes panes [FF68+] ***/
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        /* 0322: disable personalized Extension Recommendations in about:addons and AMO [FF65+]
         * [NOTE] This pref has no effect when Health Reports (0331) are disabled
         * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to make personalized extension recommendations
         * [1] https://support.mozilla.org/kb/personalized-extension-recommendations ***/
        "browser.discovery.enabled" = false;

        /** TELEMETRY ***/
        /* 0330: disable new data submission [FF41+]
         * If disabled, no policy is shown or upload takes place, ever
         * [1] https://bugzilla.mozilla.org/1195552 ***/
        "datareporting.policy.dataSubmissionEnabled" = false;
        /* 0331: disable Health Reports
         * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send technical... data ***/
        "datareporting.healthreport.uploadEnabled" = false;
        /* 0332: disable telemetry
         * The "unified" pref affects the behavior of the "enabled" pref
         * - If "unified" is false then "enabled" controls the telemetry module
         * - If "unified" is true then "enabled" only controls whether to record extended data
         * [NOTE] "toolkit.telemetry.enabled" is now LOCKED to reflect prerelease (true) or release builds (false) [2]
         * [1] https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html
         * [2] https://medium.com/georg-fritzsche/data-preference-changes-in-firefox-58-2d5df9c428b5 ***/
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false; # see [NOTE]
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false; # [FF55+]
        "toolkit.telemetry.shutdownPingSender.enabled" = false; # [FF55+]
        "toolkit.telemetry.updatePing.enabled" = false; # [FF56+]
        "toolkit.telemetry.bhrPing.enabled" = false; # [FF57+] Background Hang Reporter
        "toolkit.telemetry.firstShutdownPing.enabled" = false; # [FF57+]
        /* 0333: disable Telemetry Coverage
         * [1] https://blog.mozilla.org/data/2018/08/20/effectively-measuring-search-in-firefox/ ***/
        "toolkit.telemetry.coverage.opt-out" = true; # [HIDDEN PREF]
        "toolkit.coverage.opt-out" = true; # [FF64+] [HIDDEN PREF]
        "toolkit.coverage.endpoint.base" = "";
        /* 0334: disable PingCentre telemetry (used in several System Add-ons) [FF57+]
         * Defense-in-depth: currently covered by 0331 ***/
        "browser.ping-centre.telemetry" = false;
        /* 0335: disable Firefox Home (Activity Stream) telemetry ***/
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        /** STUDIES ***/
        /* 0340: disable Studies
         * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to install and run studies ***/
        "app.shield.optoutstudies.enabled" = false;
        /* 0341: disable Normandy/Shield [FF60+]
         * Shield is a telemetry system that can push and test "recipes"
         * [1] https://mozilla.github.io/normandy/ ***/
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        /** CRASH REPORTS ***/
        /* 0350: disable Crash Reports ***/
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false; # [FF44+]
        /* 0351: enforce no submission of backlogged Crash Reports [FF58+]
         * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send backlogged crash reports  ***/
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # [DEFAULT: false]

        /** OTHER ***/
        /* 0360: disable Captive Portal detection
         * [1] https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-security-and-privacy ***/
        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false; # [FF52+]
        /* 0361: disable Network Connectivity checks [FF65+]
         * [1] https://bugzilla.mozilla.org/1460537 ***/
        "network.connectivity-service.enabled" = false;

        /*** [SECTION 0600]: BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on] ***/
        /* 0601: disable link prefetching
         * [1] https://developer.mozilla.org/docs/Web/HTTP/Link_prefetching_FAQ ***/
        "network.prefetch-next" = false;
        /* 0602: disable DNS prefetching
         * [1] https://developer.mozilla.org/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control ***/
        "network.dns.disablePrefetch" = true;
        /* 0603: disable predictor / prefetching ***/
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false; # [FF48+] [DEFAULT: false]
        /* 0604: disable link-mouseover opening connection to linked server
         * [1] https://news.slashdot.org/story/15/08/14/2321202/how-to-quash-firefoxs-silent-requests ***/
        "network.http.speculative-parallel-limit" = 0;
        /* 0605: disable mousedown speculative connections on bookmarks and history [FF98+] ***/
        "browser.places.speculativeConnect.enabled" = false;

        /*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS ***/
        /* 0702: set the proxy server to do any DNS lookups when using SOCKS
         * e.g. in Tor, this stops your local DNS server from knowing your Tor destination
         * as a remote Tor node will handle the DNS request
         * [1] https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO/WebBrowsers ***/
        "network.proxy.socks_remote_dns" = true;
        /* 0703: disable using UNC (Uniform Naming Convention) paths [FF61+]
         * [SETUP-CHROME] Can break extensions for profiles on network shares
         * [1] https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/26424 ***/
        "network.file.disable_unc_paths" = true; # [HIDDEN PREF]
        /* 0704: disable GIO as a potential proxy bypass vector
         * Gvfs/GIO has a set of supported protocols like obex, network, archive, computer,
         * dav, cdda, gphoto2, trash, etc. By default only sftp is accepted (FF87+)
         * [1] https://bugzilla.mozilla.org/1433507
         * [2] https://en.wikipedia.org/wiki/GVfs
         * [3] https://en.wikipedia.org/wiki/GIO_(software) ***/
        "network.gio.supported-protocols" = ""; # [HIDDEN PREF]

        /*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
        /* 0805: disable location bar making speculative connections [FF56+]
         * [1] https://bugzilla.mozilla.org/1348275 ***/
        "browser.urlbar.speculativeConnect.enabled" = false;
        /* 0807: disable location bar contextual suggestions [FF92+]
         * [SETTING] Privacy & Security>Address Bar>Suggestions from...
         * [1] https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/ ***/
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false; # [FF95+]
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        /* 0810: disable search and form history
         * [SETUP-WEB] Be aware that autocomplete form data can be read by third parties [1][2]
         * [NOTE] We also clear formdata on exit (2811)
         * [SETTING] Privacy & Security>History>Custom Settings>Remember search and form history
         * [1] https://blog.mindedsecurity.com/2011/10/autocompleteagain.html
         * [2] https://bugzilla.mozilla.org/381681 ***/
        "browser.formfill.enable" = false;

        /*** [SECTION 0900]: PASSWORDS
           [1] https://support.mozilla.org/kb/use-primary-password-protect-stored-logins-and-pas
        ***/
        /* 0903: disable auto-filling username & password form fields
         * can leak in cross-site forms *and* be spoofed
         * [NOTE] Username & password is still available when you enter the field
         * [SETTING] Privacy & Security>Logins and Passwords>Autofill logins and passwords
         * [1] https://freedom-to-tinker.com/2017/12/27/no-boundaries-for-user-identities-web-trackers-exploit-browser-login-managers/
         * [2] https://homes.esat.kuleuven.be/~asenol/leaky-forms/ ***/
        "signon.autofillForms" = false;
        /* 0904: disable formless login capture for Password Manager [FF51+] ***/
        "signon.formlessCapture.enabled" = false;
        /* 0905: limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources [FF41+]
         * hardens against potential credentials phishing
         * 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
         * 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
         * 2 = allow sub-resources to open HTTP authentication credentials dialogs (default) ***/
        "network.auth.subresource-http-auth-allow" = 1;

        /*** [SECTION 1000]: DISK AVOIDANCE ***/
        /* 1002: disable media cache from writing to disk in Private Browsing
         * [NOTE] MSE (Media Source Extensions) are already stored in-memory in PB ***/
        "browser.privatebrowsing.forceMediaMemoryCache" = true; # [FF75+]
        "media.memory_cache_max_size" = 65536;
        /* 1003: disable storing extra session data [SETUP-CHROME]
         * define on which sites to save extra session data such as form content, cookies and POST data
         * 0=everywhere, 1=unencrypted sites, 2=nowhere ***/
        "browser.sessionstore.privacy_level" = 2;
        /* 1006: disable favicons in shortcuts
         * URL shortcuts use a cached randomly named .ico file which is stored in your
         * profile/shortcutCache directory. The .ico remains after the shortcut is deleted
         * If set to false then the shortcuts use a generic Firefox icon ***/
        "browser.shell.shortcutFavicons" = false;

        /*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
           Your cipher and other settings can be used in server side fingerprinting
           [TEST] https://www.ssllabs.com/ssltest/viewMyClient.html
           [TEST] https://browserleaks.com/ssl
           [TEST] https://ja3er.com/
           [1] https://www.securityartwork.es/2017/02/02/tls-client-fingerprinting-with-bro/
        ***/
        /** SSL (Secure Sockets Layer) / TLS (Transport Layer Security) ***/
        /* 1201: require safe negotiation
         * Blocks connections to servers that don't support RFC 5746 [2] as they're potentially vulnerable to a
         * MiTM attack [3]. A server without RFC 5746 can be safe from the attack if it disables renegotiations
         * but the problem is that the browser can't know that. Setting this pref to true is the only way for the
         * browser to ensure there will be no unsafe renegotiations on the channel between the browser and the server
         * [SETUP-WEB] SSL_ERROR_UNSAFE_NEGOTIATION: is it worth overriding this for that one site?
         * [STATS] SSL Labs (Feb 2023) reports over 99.3% of top sites have secure renegotiation [4]
         * [1] https://wiki.mozilla.org/Security:Renegotiation
         * [2] https://datatracker.ietf.org/doc/html/rfc5746
         * [3] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3555
         * [4] https://www.ssllabs.com/ssl-pulse/ ***/
        "security.ssl.require_safe_negotiation" = true;
        /* 1206: disable TLS1.3 0-RTT (round-trip time) [FF51+]
         * This data is not forward secret, as it is encrypted solely under keys derived using
         * the offered PSK. There are no guarantees of non-replay between connections
         * [1] https://github.com/tlswg/tls13-spec/issues/1001
         * [2] https://www.rfc-editor.org/rfc/rfc9001.html#name-replay-attacks-with-0-rtt
         * [3] https://blog.cloudflare.com/tls-1-3-overview-and-q-and-a/ ***/
        "security.tls.enable_0rtt_data" = false;

        /** OCSP (Online Certificate Status Protocol)
           [1] https://scotthelme.co.uk/revocation-is-broken/
           [2] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
        ***/
        /* 1211: enforce OCSP fetching to confirm current validity of certificates
         * 0=disabled, 1=enabled (default), 2=enabled for EV certificates only
         * OCSP (non-stapled) leaks information about the sites you visit to the CA (cert authority)
         * It's a trade-off between security (checking) and privacy (leaking info to the CA)
         * [NOTE] This pref only controls OCSP fetching and does not affect OCSP stapling
         * [SETTING] Privacy & Security>Security>Certificates>Query OCSP responder servers...
         * [1] https://en.wikipedia.org/wiki/Ocsp ***/
        "security.OCSP.enabled" = 1; # [DEFAULT: 1]
        /* 1212: set OCSP fetch failures (non-stapled, see 1211) to hard-fail
         * [SETUP-WEB] SEC_ERROR_OCSP_SERVER_ERROR
         * When a CA cannot be reached to validate a cert, Firefox just continues the connection (=soft-fail)
         * Setting this pref to true tells Firefox to instead terminate the connection (=hard-fail)
         * It is pointless to soft-fail when an OCSP fetch fails: you cannot confirm a cert is still valid (it
         * could have been revoked) and/or you could be under attack (e.g. malicious blocking of OCSP servers)
         * [1] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
         * [2] https://www.imperialviolet.org/2014/04/19/revchecking.html ***/
        "security.OCSP.require" = true;

        /** CERTS / HPKP (HTTP Public Key Pinning) ***/
        /* 1223: enable strict PKP (Public Key Pinning)
         * 0=disabled, 1=allow user MiTM (default; such as your antivirus), 2=strict
         * [SETUP-WEB] MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE ***/
        "security.cert_pinning.enforcement_level" = 2;
        /* 1224: enable CRLite [FF73+]
         * 0 = disabled
         * 1 = consult CRLite but only collect telemetry
         * 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
         * 3 = consult CRLite and enforce "Not Revoked" results, but defer to OCSP for "Revoked" (FF99+, default FF100+)
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1429800,1670985,1753071
         * [2] https://blog.mozilla.org/security/tag/crlite/ ***/
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        /** MIXED CONTENT ***/
        /* 1244: enable HTTPS-Only mode in all windows [FF76+]
         * When the top-level is HTTPS, insecure subresources are also upgraded (silent fail)
         * [SETTING] to add site exceptions: Padlock>HTTPS-Only mode>On (after "Continue to HTTP Site")
         * [SETTING] Privacy & Security>HTTPS-Only Mode (and manage exceptions)
         * [TEST] http://example.com [upgrade]
         * [TEST] http://httpforever.com/ | http://http.rip [no upgrade] ***/
        "dom.security.https_only_mode" = true; # [FF76+]
        /* 1246: disable HTTP background requests [FF82+]
         * When attempting to upgrade, if the server doesn't respond within 3 seconds, Firefox sends
         * a top-level HTTP request without path in order to check if the server supports HTTPS or not
         * This is done to avoid waiting for a timeout which takes 90 seconds
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1642387,1660945 ***/
        "dom.security.https_only_mode_send_http_background_request" = false;

        /** UI (User Interface) ***/
        /* 1270: display warning on the padlock for "broken security" (if 1201 is false)
         * Bug: warning padlock not indicated for subresources on a secure page! [2]
         * [1] https://wiki.mozilla.org/Security:Renegotiation
         * [2] https://bugzilla.mozilla.org/1353705 ***/
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        /* 1272: display advanced information on Insecure Connection warning pages
         * only works when it's possible to add an exception
         * i.e. it doesn't work for HSTS discrepancies (https://subdomain.preloaded-hsts.badssl.com/)
         * [TEST] https://expired.badssl.com/ ***/
        "browser.xul.error_pages.expert_bad_cert" = true;

        /*** [SECTION 1600]: HEADERS / REFERERS
                          full URI: https://example.com:8888/foo/bar.html?id=1234
             scheme+host+port+path: https://example.com:8888/foo/bar.html
                  scheme+host+port: https://example.com:8888
           [1] https://feeding.cloud.geek.nz/posts/tweaking-referrer-for-privacy-in-firefox/
        ***/
        /* 1601: control when to send a cross-origin referer
         * 0=always (default), 1=only if base domains match, 2=only if hosts match
         * [SETUP-WEB] Breakage: older modems/routers and some sites e.g banks, vimeo, icloud, instagram
         * If "2" is too strict, then override to "0" and use Smart Referer extension (Strict mode + add exceptions) ***/
        "network.http.referer.XOriginPolicy" = 2;
        /* 1602: control the amount of cross-origin information to send [FF52+]
         * 0=send full URI (default), 1=scheme+host+port+path, 2=scheme+host+port ***/
        "network.http.referer.XOriginTrimmingPolicy" = 2;

        /*** [SECTION 1700]: CONTAINERS ***/
        /* 1701: enable Container Tabs and its UI setting [FF50+]
         * [SETTING] General>Tabs>Enable Container Tabs
         * https://wiki.mozilla.org/Security/Contextual_Identity_Project/Containers ***/
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        /*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
        /* 2002: force WebRTC inside the proxy [FF70+] ***/
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        /* 2003: force a single network interface for ICE candidates generation [FF42+]
         * When using a system-wide proxy, it uses the proxy interface
         * [1] https://developer.mozilla.org/en-US/docs/Web/API/RTCIceCandidate
         * [2] https://wiki.mozilla.org/Media/WebRTC/Privacy ***/
        "media.peerconnection.ice.default_address_only" = true;
        /* 2022: disable all DRM content (EME: Encryption Media Extension)
         * Optionally hide the setting which also disables the DRM prompt
         * [SETUP-WEB] e.g. Netflix, Amazon Prime, Hulu, HBO, Disney+, Showtime, Starz, DirectTV
         * [SETTING] General>DRM Content>Play DRM-controlled content
         * [TEST] https://bitmovin.com/demos/drm
         * [1] https://www.eff.org/deeplinks/2017/10/drms-dead-canary-how-we-just-lost-web-what-we-learned-it-and-what-we-need-do-next ***/
        "media.eme.enabled" = false;

        /*** [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL) ***/
        /* 2402: prevent scripts from moving and resizing open windows ***/
        "dom.disable_window_move_resize" = true;

        /*** [SECTION 2600]: MISCELLANEOUS ***/
        /* 2601: prevent accessibility services from accessing your browser [RESTART]
         * [1] https://support.mozilla.org/kb/accessibility-services ***/
        "accessibility.force_disabled" = 1;
        /* 2603: remove temp files opened with an external application
         * [1] https://bugzilla.mozilla.org/302433 ***/
        "browser.helperApps.deleteTempFileOnExit" = true;
        /* 2606: disable UITour backend so there is no chance that a remote page can use it ***/
        "browser.uitour.enabled" = false;
        /* 2608: reset remote debugging to disabled
         * [1] https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/16222 ***/
        "devtools.debugger.remote-enabled" = false; # [DEFAULT: false]
        /* 2616: remove special permissions for certain mozilla domains [FF35+]
         * [1] resource://app/defaults/permissions ***/
        "permissions.manager.defaultsUrl" = "";
        /* 2617: remove webchannel whitelist ***/
        "webchannel.allowObject.urlWhitelist" = "";
        /* 2619: use Punycode in Internationalized Domain Names to eliminate possible spoofing
         * [SETUP-WEB] Might be undesirable for non-latin alphabet users since legitimate IDN's are also punycoded
         * [TEST] https://www.xn--80ak6aa92e.com/ (www.apple.com)
         * [1] https://wiki.mozilla.org/IDN_Display_Algorithm
         * [2] https://en.wikipedia.org/wiki/IDN_homograph_attack
         * [3] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=punycode+firefox
         * [4] https://www.xudongz.com/blog/2017/idn-phishing/ ***/
        "network.IDN_show_punycode" = true;
        /* 2620: enforce PDFJS, disable PDFJS scripting
         * This setting controls if the option "Display in Firefox" is available in the setting below
         *   and by effect controls whether PDFs are handled in-browser or externally ("Ask" or "Open With")
         * [WHY] pdfjs is lightweight, open source, and secure: the last exploit was June 2015 [1]
         *   It doesn't break "state separation" of browser content (by not sharing with OS, independent apps).
         *   It maintains disk avoidance and application data isolation. It's convenient. You can still save to disk.
         * [NOTE] JS can still force a pdf to open in-browser by bundling its own code
         * [SETUP-CHROME] You may prefer a different pdf reader for security/workflow reasons
         * [SETTING] General>Applications>Portable Document Format (PDF)
         * [1] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=pdf.js+firefox ***/
        "pdfjs.disabled" = false; # [DEFAULT: false]
        "pdfjs.enableScripting" = false; # [FF86+]
        /* 2623: disable permissions delegation [FF73+]
         * Currently applies to cross-origin geolocation, camera, mic and screen-sharing
         * permissions, and fullscreen requests. Disabling delegation means any prompts
         * for these will show/use their correct 3rd party origin
         * [1] https://groups.google.com/forum/#!topic/mozilla.dev.platform/BdFOMAuCGW8/discussion ***/
        "permissions.delegation.enabled" = false;
        /* 2624: disable middle click on new tab button opening URLs or searches using clipboard [FF115+] */
        "browser.tabs.searchclipboardfor.middleclick" = false; # [DEFAULT: false NON-LINUX]

        /** DOWNLOADS ***/
        /* 2651: enable user interaction for security by always asking where to download
         * [SETUP-CHROME] On Android this blocks longtapping and saving images
         * [SETTING] General>Downloads>Always ask you where to save files ***/
        "browser.download.useDownloadDir" = false;
        /* 2652: disable downloads panel opening on every download [FF96+] ***/
        "browser.download.alwaysOpenPanel" = false;
        /* 2653: disable adding downloads to the system's "recent documents" list ***/
        "browser.download.manager.addToRecentDocs" = false;
        /* 2654: enable user interaction for security by always asking how to handle new mimetypes [FF101+]
         * [SETTING] General>Files and Applications>What should Firefox do with other files ***/
        "browser.download.always_ask_before_handling_new_types" = true;

        /** EXTENSIONS ***/
        /* 2660: lock down allowed extension directories
         * [SETUP-CHROME] This will break extensions, language packs, themes and any other
         * XPI files which are installed outside of profile and application directories
         * [1] https://mike.kaply.com/2012/02/21/understanding-add-on-scopes/
         * [1] https://archive.is/DYjAM (archived) ***/
        "extensions.enabledScopes" = 5; # [HIDDEN PREF]
        "extensions.autoDisableScopes" = 15; # [DEFAULT: 15]
        /* 2661: disable bypassing 3rd party extension install prompts [FF82+]
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1659530,1681331 ***/
        "extensions.postDownloadThirdPartyPrompt" = false;

        /*** [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ***/
        /* 2701: enable ETP Strict Mode [FF86+]
         * ETP Strict Mode enables Total Cookie Protection (TCP)
         * [NOTE] Adding site exceptions disables all ETP protections for that site and increases the risk of
         * cross-site state tracking e.g. exceptions for SiteA and SiteB means PartyC on both sites is shared
         * [1] https://blog.mozilla.org/security/2021/02/23/total-cookie-protection/
         * [SETTING] to add site exceptions: Urlbar>ETP Shield
         * [SETTING] to manage site exceptions: Options>Privacy & Security>Enhanced Tracking Protection>Manage Exceptions ***/
        "browser.contentblocking.category" = "strict";
        /* 2710: enable state partitioning of service workers [FF96+] ***/
        "privacy.partition.serviceWorkers" = true; # [DEFAULT: true FF105+]
        /* 2720: enable APS (Always Partitioning Storage) ***/
        "privacy.partition.always_partition_third_party_non_cookie_storage" = true; # [FF104+] [DEFAULT: true FF109+]
        "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false; # [FF105+] [DEFAULT: false FF109+]

        /*** [SECTION 6000]: DON'T TOUCH ***/
        /* 6001: enforce Firefox blocklist
         * [WHY] It includes updates for "revoked certificates"
         * [1] https://blog.mozilla.org/security/2015/03/03/revoking-intermediate-certificates-introducing-onecrl/ ***/
        "extensions.blocklist.enabled" = true; # [DEFAULT: true]
        /* 6002: enforce no referer spoofing
         * [WHY] Spoofing can affect CSRF (Cross-Site Request Forgery) protections ***/
        "network.http.referer.spoofSource" = false; # [DEFAULT: false]
        /* 6004: enforce a security delay on some confirmation dialogs such as install, open/save
         * [1] https://www.squarefree.com/2004/07/01/race-conditions-in-security-dialogs/ ***/
        "security.dialog_enable_delay" = 1000; # [DEFAULT: 1000]
        /* 6008: enforce no First Party Isolation [FF51+]
         * [WARNING] Replaced with network partitioning (FF85+) and TCP (2701), and enabling FPI
         * disables those. FPI is no longer maintained except at Tor Project for Tor Browser's config ***/
        "privacy.firstparty.isolate" = false; # [DEFAULT: false]
        /* 6009: enforce SmartBlock shims [FF81+]
         * In FF96+ these are listed in about:compat
         * [1] https://blog.mozilla.org/security/2021/03/23/introducing-smartblock/ ***/
        "extensions.webcompat.enable_shims" = true; # [DEFAULT: true]
        /* 6010: enforce no TLS 1.0/1.1 downgrades
         * [TEST] https://tls-v1-1.badssl.com:1010/ ***/
        "security.tls.version.enable-deprecated" = false; # [DEFAULT: false]
        /* 6011: enforce disabling of Web Compatibility Reporter [FF56+]
         * Web Compatibility Reporter adds a "Report Site Issue" button to send data to Mozilla
         * [WHY] To prevent wasting Mozilla's time with a custom setup ***/
        "extensions.webcompat-reporter.enabled" = false; # [DEFAULT: false]
        /* 6012: enforce Quarantined Domains [FF115+]
         * [WHY] https://support.mozilla.org/kb/quarantined-domains */
        "extensions.quarantinedDomains.enabled" = true; # [DEFAULT: true]
      };
    };
  };
}
