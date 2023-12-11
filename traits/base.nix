/*
  A trait for all boxxen
*/
{ pkgs, ... }:

{
  config = {
    time.timeZone = "Africa/Johannesburg";

    i18n.defaultLocale = "en_ZA.UTF-8";
    i18n.supportedLocales = [ "all" ];
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };

    environment.systemPackages = with pkgs; [
      # Shell utilities
      patchelf
      direnv
      nix-direnv
      git
      jq
      fzf
      ripgrep
      lsof
      htop
      bat
      grex
      broot
      bottom
      fd
      sd
      fio
      hyperfine
      tokei
      bandwhich
      lsd
      ntfs3g
      # nvme-cli
      # nvmet-cli
      # libhugetlbfs # This has a build failure.
      killall
      gptfdisk
      fio
      smartmontools
      rnix-lsp
      graphviz
      simple-http-server
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

    security.sudo.wheelNeedsPassword = false;
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

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
