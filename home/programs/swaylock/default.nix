{ pkgs, ... }: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      clock = true;
      effect-blur = "8x5";
      effect-vignette = "0.5:0.5";
      ignore-empty-password = true;
      indicator = true;
      image = "~/flake/home/wallpapers/flow.jpg";
      grace = 2;
      ring-color = "#FF9F1C";
    };
  };
}
