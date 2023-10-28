{ ... }: {
  programs.atuin = {
    enable = true;
    # flags = [ "--disable-up-arrow" ];
    enableNushellIntegration = true;
  };
}
