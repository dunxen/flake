{ atuin-main, system, ... }: {
  programs.atuin = {
    enable = true;
    package = atuin-main.packages."${system}".default;
    enableNushellIntegration = true;
    settings = {
      db_path = "/tmpdata/atuin/history.db";
    };
  };
}
