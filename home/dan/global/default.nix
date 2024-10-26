{ lib, config, pkgs, inputs, outputs, ... }: {
  imports = [
    ../features/cli
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Dan Greco";
      userEmail = "me@dangre.co";
    };
  };

  home = {
    username = lib.mkDefault "dan";
    homeDirectory = lib.mkDefault "/home/dan";
    stateVersion = lib.mkDefault "24.05";
  };

  dconf = {
    enable = true;
    settings = {
      # Center new windows
      "org/gnome/mutter" = {
        center-new-windows = true;
      };
      # Button layout
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
      # Wallpaper
      "org/gnome/desktop/screensaver" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.jxl";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.jxl";
        primary-color = "#3071AE";
        secondary-color = "#000000";
      };
    };
  };
}