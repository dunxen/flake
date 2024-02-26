{ ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        font = wezterm.font("JetBrainsMono Nerd Font"),
        color_scheme = 'Google Dark (base16)',
      }
    '';
  };
}
