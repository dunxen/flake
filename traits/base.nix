/*
  A trait for all boxxen
*/
{ pkgs, lib, ... }:

{
  config = {
    time.timeZone = "Africa/Johannesburg";

    i18n.defaultLocale = "en_ZA.UTF-8";
    i18n.supportedLocales = [ "all" ];
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-hangul
        fcitx5-gtk
      ];
    };

    documentation.dev.enable = true;

    environment.systemPackages = with pkgs; [
      # Shell utilities
      bandwhich
      bat
      bottom
      broot
      direnv
      fd
      fio
      fio
      fzf
      git
      gptfdisk
      graphviz
      grex
      htop
      hyperfine
      jq
      killall
      # libhugetlbfs # This has a build failure.
      lsd
      lsof
      man-pages
      man-pages-posix
      nix-direnv
      ntfs3g
      # nvme-cli
      # nvmet-cli
      patchelf
      ripgrep
      # rnix-lsp
      sd
      simple-http-server
      smartmontools
      tokei
    ];
    environment.shellAliases = { };
    environment.variables = {
      EDITOR = "${pkgs.helix}/bin/hx";
    };
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];

    programs.bash.shellInit = ''
    '';
    programs.bash.loginShellInit = ''
      HAS_SHOWN_NEOFETCH=''${HAS_SHOWN_NEOFETCH:-false}
      if [[ $- == *i* ]] && [[ "$HAS_SHOWN_NEOFETCH" == "false" ]]; then
        ${pkgs.neofetch}/bin/neofetch --config ${../config/neofetch/config}
        HAS_SHOWN_NEOFETCH=true
      fi
    '';
    programs.bash.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      source "${pkgs.fzf}/share/fzf/key-bindings.bash"
      source "${pkgs.fzf}/share/fzf/completion.bash"
    '';

    programs.mosh.enable = true;

    security.sudo.enable = lib.mkForce false;
    security.sudo-rs.enable = true;
    security.sudo-rs.wheelNeedsPassword = false;

    # Use edge NixOS.
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    # Hack: https://github.com/NixOS/nixpkgs/issues/180175
    # systemd.services.systemd-udevd.restartIfChanged = false;
    systemd.services.NetworkManager-wait-online = {
      serviceConfig = {
        ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
      };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
