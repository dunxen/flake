{ ... }:
let
  font_family = "Inter";
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 9;
          noise = 0.0117;
          contrast = 0.916;
          brightness = 0.8172;
          vibrancy = 0.1696;
        }
      ];

      input-field = [
        {
          monitor = "";

          size = "300, 50";

          outline_thickness = 1;

          outer_color = "rgb(210,210,210)";
          inner_color = "rgb(80,80,80)";
          font_color = "rgb(220,220,220)";

          fade_on_empty = false;
          # placeholder_text = ''<span font_family="${font_family}" foreground="##${c.primary_container}">Password...</span>'';
          placeholder_text = ''<span font_family="${font_family}">Password...</span>'';

          dots_spacing = 0.2;
          dots_center = true;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          inherit font_family;
          font_size = 50;
          color = "rgb(210,210,210)";

          position = "0, 150";

          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:3600000] date +'%a %b %d'";
          inherit font_family;
          font_size = 20;
          color = "rgb(210,210,210)";

          position = "0, 50";

          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
