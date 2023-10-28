{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    };
  };
}
