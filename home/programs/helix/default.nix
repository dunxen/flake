{ helix-master, system, ... }: {
  programs.helix = {
    enable = true;
    package = helix-master.packages."${system}".default;
    languages = {
      language-server = {
        nls = {
          command = "nls";
        };
        nil = {
          command = "nil";
        };
        deno = {
          command = "deno";
          args = [ "lsp" ];
        };
      };
      language = [
        {
          name = "rust";
          indent = {
            tab-width = 4;
            unit = "\t";
          };
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
          language-servers = [ "nls" ];
        }
        {
          name = "nix";
          language-servers = [ "nil" ];
        }
        {
          name = "jsx";
          language-servers = [ "deno" ];
          auto-format = true;
        }
        {
          name = "tsx";
          language-servers = [ "deno" ];
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [ "deno" ];
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [ "deno" ];
          auto-format = true;
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
