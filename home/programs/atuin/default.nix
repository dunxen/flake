{ atuin-main, system, ... }: {
  programs.atuin = {
    enable = true;
    package = atuin-main.packages."${system}".default;
    enableNushellIntegration = true;
    settings = {
      # seems to be broken
      # daemon = {
      #   enabled = true;
      # };
    };
  };
}
