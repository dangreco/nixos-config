{ pkgs, lib, ... }: 
{
  imports = [ 
    ./global
    ../common/apps/_1password.nix
    ../common/apps/gnome-tweaks.nix
    ../common/browsers/firefox.nix
    ../common/themes/firefox-gnome-theme.nix
    ../common/themes/kora.nix
    ../common/editors/eclipse.nix
    ../common/editors/vscode.nix
    ../common/terminal-emulators/blackbox.nix
  ];

  dconf = {
    enable = true;
    settings = with lib.hm.gvariant; {
      "org/gnome/desktop/session" = {
        idle-delay = mkUint32 0;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = false;
      };
      "com/raggesilver/BlackBox" = 
        let 
          padding = mkUint32 12;
        in
        {
          font = "JetBrainsMono Nerd Font Mono 10";
          cursor-shape = mkUint32 1; # IBeam
          terminal-bell = false;
          terminal-padding = mkTuple [ padding padding padding padding ];
        };
    };
  };
}
