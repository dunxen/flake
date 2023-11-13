{ pkgs, ... }:
let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in
{
  # screen idle
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${pkgs.gtklock}/bin/gtklock -d";
      }
    ];
    timeouts = [
      {
        timeout = 240;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      # {
      #   timeout = 3600;
      #   command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
      # }
      {
        timeout = 3600;
        command = suspendScript.outPath;
      }
    ];
  };
}
