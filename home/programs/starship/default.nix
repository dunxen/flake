{ ... }: {
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
}
