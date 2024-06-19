{ pkgs
, lib
, config
, ...
}:
let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  # brillo = lib.getExe pkgs.brillo;

  # timeout after which DPMS kicks in
  timeout = 300;
in
{
  # screen idle
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # {
        #   timeout = timeout - 10;
        #   # save the current brightness and dim the screen over a period of
        #   # 1 second
        #   on-timeout = "${brillo} -O; ${brillo} -u 1000000 -S 10";
        #   # brighten the screen over a period of 500ms to the saved value
        #   on-resume = "${brillo} -I -u 500000";
        # }
        {
          timeout = timeout - 10;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          inherit timeout;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = timeout + 3600;
          on-timeout = suspendScript.outPath;
        }
      ];
    };
  };
}
