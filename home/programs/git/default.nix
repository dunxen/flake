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
      ca = "commit --amend";
      c = "commit";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      dm = "diff --color-moved=plain";
      ds = "diff --staged";
      forgor = "commit --amend --no-edit";
      fpush = "push --force-with-lease";
      graph = "log --all --decorate --graph --oneline";
      l = "log";
      oops = "checkout --";
      pf = "push --force-with-lease";
      pl = "pull";
      p = "push";
      r = "rebase";
      showm = "show --color-moved=plain";
      ss = "status";
      s = "status --short";
      staash = "stash --all";
    };
    ignores = [ "*~" "*.swp" "*result*" ".direnv" "node_modules" ];
    lfs.enable = true;
    extraConfig = {
      branch.sort = "-committerdate";
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
      rerere.enabled = true;
      # maintenance.repo = "/home/dunxen/repos/github.com/dunxen/rust-lightning";
    };
  };
}
