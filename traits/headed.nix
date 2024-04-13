/*
  A trait for headed boxxen
*/
{ pkgs, hyprland, ... }:

{
  config = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.displayManager.autoLogin.enable = false;

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
