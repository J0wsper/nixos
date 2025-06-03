{ pkgs, inputs, lib, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "J0wsper";
        email = "bramschuijff03@gmail.com";
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_pushable(to)" =
          ''heads(::to & ~description(exact:"") & (~empty() | merges()))'';
      };
      aliases = {
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@)"
          "--to"
          "closest_pushable(@)"
        ];
      };
      git = {
        auto-local-remotes = true;
        private-commits = "description(glob:'private:*')";
      };
      ui = {
        pager = "less -FRX --mouse";
        default-command = "log";
      };
    };
  };
}
