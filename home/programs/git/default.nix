{ pkgs, ... }:
let
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs8y3pGOgEefYi6juRp+RECFq/uzYu7o3Qc6Wo0RD90 git@dunxen.dev";
in
{
  programs.git = {
    enable = true;
    userName = "Duncan Dean";
    userEmail = "git@dunxen.dev";
    signing = {
      key = ssh_key;
      signByDefault = true;
    };
    aliases = {
      a = "add";
      b = "branch";
      c = "commit";
      ca = "commit --amend";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      dm = "diff --color-moved=plain";
      ds = "diff --staged";
      p = "push";
      pf = "push --force-with-lease";
      pl = "pull";
      l = "log";
      r = "rebase";
      s = "status --short";
      showm = "show --color-moved=plain";
      ss = "status";
      forgor = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      oops = "checkout --";
    };
    ignores = [ "*~" "*.swp" "*result*" ".direnv" "node_modules" ];
    lfs.enable = true;
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      diff.colormoved = "zebra";
      core = {
        editor = "hx";
        pager = "delta";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = true;
        light = false;
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      gpg.format = "ssh";
      gpg.ssh.program = ''${pkgs._1password-gui}/share/1password/op-ssh-sign'';
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };
}
