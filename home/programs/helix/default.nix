{ ... }: {
  programs.helix = {
    enable = true;
    languages = {
      language = [
        {
          name = "rust";
          indent = {
            tab-width = 4;
            unit = "\t";
          };
        }
        {
          name = "typst";
          scope = "source.typst";
          injection-regex = "^typ(st)?$";
          file-types = [ "typ" ];
          roots = [ ];
          comment-token = "//";
          # language-server = {
          #   command = "typst-lsp";
          # };
          # config = {
          #   exportPdf = "onType";
          # };
        }
        {
          name = "nickel";
          indent = {
            tab-width = 2;
            unit = "\t";
          };
          scope = "source.nickel";
          injection-regex = "^ni?c(ke)?l$";
          file-types = [ "ncl" ];
          roots = [ ];
          comment-token = "#";
          # language-server = {
          #   command = "nls";
          # };
        }
        {
          name = "nix";
          # language-server = {
          #   command = "nil";
          # };
        }
      ];
    };
    settings = {
      theme = "varua";
      editor = {
        line-number = "relative";
        color-modes = true;
        indent-guides = {
          render = true;
          character = "¦";
          skip-levels = 1;
        };
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            newline = "none";
          };
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };
        file-picker.hidden = false;
      };
    };
  };
}
