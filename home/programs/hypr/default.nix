{ pkgs, lib, self, ... }:

{
  imports = [ 
    ./hyprland-environment.nix
  ];

  home.packages = with pkgs; [ 
    waybar
    swww
    polkit-kde-agent
  ];

  # start swayidle as part of hyprland, not sway
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''

    # Monitor
    monitor=DP-1,3840x2160@60,auto,1

    # Fix slow startup
    exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 

    # Autostart

    exec-once = hyprctl setcursor Bibata-Modern-Classic 24
    exec-once = dunst
    exec-once = ${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1

    source = /home/dunxen/.config/hypr/colors
    exec = pkill waybar & sleep 0.5 && waybar --style '${self}/home/programs/hypr/waybar/style.css' --config '${self}/home/programs/hypr/waybar/config'
    exec-once = swww init & sleep 0.5
    exec-once = swww img ${self}/home/wallpapers/flow.jpg

    # Input config
    input {
        follow_mouse = 1
        natural_scroll = 1

        touchpad {
            natural_scroll = false
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = dwindle
    }

    misc {
        mouse_move_focuses_monitor = 0
        disable_splash_rendering = 1
        mouse_move_enables_dpms = 1
    }

    decoration {

        rounding = 10
        blur {
            enabled = true
            size = 3
            passes = 1
        }

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = yes

        bezier = ease,0.4,0.02,0.21,1

        animation = windows, 1, 3.5, ease, slide
        animation = windowsOut, 1, 3.5, ease, slide
        animation = border, 1, 6, default
        animation = fade, 1, 3, ease
        animation = workspaces, 1, 3.5, ease
    }

    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    master {
        new_is_master = yes
    }

    gestures {
        workspace_swipe = false
    }

    # Example windowrule v1
    # windowrule = float, ^(alacritty)$
    # Example windowrule v2
    # windowrulev2 = float,class:^(alacritty)$,title:^(alacritty)$

    windowrule=float,org.kde.polkit-kde-authentication-agent-1
    windowrule=float,^(alacritty)$
    windowrule=float,^(pavucontrol)$
    windowrule=center,^(alacritty)$
    windowrule=float,^(blueman-manager)$
    windowrule=size 600 500,^(alacritty)$
    windowrule=size 934 525,^(mpv)$
    windowrule=float,^(mpv)$
    windowrule=center,^(mpv)$
    #windowrule=pin,^(firefox)$

    workspace = 1, monitor:HDMI-A-1
    workspace = 2, monitor:DP-3, default:true
    workspace = 3, monitor:DVI-D-1
    workspace = 4, monitor:HDMI-A-1
    workspace = 5, monitor:DP-3
    workspace = 6, monitor:DVI-D-1
    workspace = 7, monitor:HDMI-A-1
    workspace = 8, monitor:DP-3
    workspace = 9, monitor:DVI-D-1

    $mainMod = SUPER
    bind = $mainMod, G, fullscreen,

    bind = $mainMod, RETURN, exec, alacritty
    bind = $mainMod, B, exec, firefox
    bind = $mainMod, Q, killactive,
    bind = $mainMod SHIFT, L, exec, gtklock
    bind = $mainMod SHIFT, E, exit,
    bind = $mainMod, F, exec, nautilus
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, D, exec, rofi -show drun
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, S, togglesplit, # dwindle

    # Switch Keyboard Layouts
    bind = $mainMod, SPACE, exec, hyprctl switchxkblayout teclado-gamer-husky-blizzard next

    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = SHIFT, Print, exec, grim -g "$(slurp)"

    # Functional keybinds
    bind =,XF86AudioMicMute,exec,pamixer --default-source -t
    bind =,XF86MonBrightnessDown,exec,light -U 20
    bind =,XF86MonBrightnessUp,exec,light -A 20
    bind =,XF86AudioMute,exec,pamixer -t
    bind =,XF86AudioLowerVolume,exec,pamixer -d 10
    bind =,XF86AudioRaiseVolume,exec,pamixer -i 10
    bind =,XF86AudioPlay,exec,playerctl play-pause
    bind =,XF86AudioPause,exec,playerctl play-pause

    # to switch between windows in a floating workspace
    bind = SUPER,Tab,cyclenext,
    bind = SUPER,Tab,bringactivetotop,

    # Move focus with mainMod + arrow keys
    bind = $mainMod, h, movefocus, l
    bind = $mainMod, l, movefocus, r
    bind = $mainMod, k, movefocus, u
    bind = $mainMod, j, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
    bindm = ALT, mouse:272, resizewindow
        '';
  };

      home.file.".config/hypr/colors".text = ''
$background = rgba(1d192bee)
$foreground = rgba(c3dde7ee)

$color0 = rgba(1d192bee)
$color1 = rgba(465EA7ee)
$color2 = rgba(5A89B6ee)
$color3 = rgba(6296CAee)
$color4 = rgba(73B3D4ee)
$color5 = rgba(7BC7DDee)
$color6 = rgba(9CB4E3ee)
$color7 = rgba(c3dde7ee)
$color8 = rgba(889aa1ee)
$color9 = rgba(465EA7ee)
$color10 = rgba(5A89B6ee)
$color11 = rgba(6296CAee)
$color12 = rgba(73B3D4ee)
$color13 = rgba(7BC7DDee)
$color14 = rgba(9CB4E3ee)
$color15 = rgba(c3dde7ee)
    '';
}