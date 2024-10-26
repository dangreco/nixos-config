{ pkgs, ... }: 
let 
  kora = pkgs.fetchFromGitHub {
    owner = "bikass";
    repo = "kora";
    rev = "d384c420fc5f0c6deacd4c3c5a37a69bfaddf603";
    hash = "sha256-4VwH+VWBA+60Gf4NO8v6SWY2b0GcAjz2fygLC9dliCM=";
  };
in
{
  home.file."kora" = {
    target = ".local/share/icons/kora";
    source = "${kora}/kora";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "kora";
      };
    };
  };
}