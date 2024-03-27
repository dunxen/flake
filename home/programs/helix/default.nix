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
          name = "html";
          language-servers = [
            "vscode-html-language-server"
            "tailwindcss-ls"
          ];
          formatter = { command = "prettier"; };
        }
        {
          name = "css";
          language-servers = [
            "vscode-css-language-server"
            "tailwindcss-ls"
          ];
          formatter = { command = "prettier"; };
        }
        {
          name = "jsx";
          language-servers = [ "typescript-language-server" "tailwindcss-ls" ];
          auto-format = true;
          formatter = { command = "prettier"; };
        }
        {
          name = "tsx";
          language-servers = [ "typescript-language-server" "tailwindcss-ls" ];
          auto-format = true;
          formatter = { command = "prettier"; };
        }
        {
          name = "javascript";
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
          formatter = { command = "prettier"; };
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
          formatter = { command = "prettier"; };
        }
        {
          name = "svelte";
          auto-format = true;
          language-servers = [
            "tailwindcss-ls"
            "svelteserver"
            "eslint-ls"
          ];
          roots = ["package.json"];
        }
        {
          name = "json";
          auto-format = false;
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
