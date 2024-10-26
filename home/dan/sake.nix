{ pkgs, ... }: {
  imports = [ 
    ./global
    ../common/apps/_1password.nix
    ../common/apps/gnome-tweaks.nix
    ../common/browsers/firefox.nix
    ../common/themes/firefox-gnome-theme.nix
    ../common/themes/kora.nix
    ../common/editors/vscode.nix
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/session" = {
        idle-delay = 0;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
      };
    };
  };
}
