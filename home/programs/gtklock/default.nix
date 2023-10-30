{
  pkgs,
  self,
  ...
}: {
  home.packages = with pkgs; [gtklock];

  xdg.configFile."gtklock/style.css".source = "${self}/home/programs/gtklock/style-dark.css";
  xdg.configFile."gtklock/config.ini".text = ''
    [main]
    background=${self}/home/wallpapers/flow_locked.jpg
  '';
}
