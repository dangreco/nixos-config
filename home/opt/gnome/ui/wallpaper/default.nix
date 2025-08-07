{ lib, config, ... }:
let
  cfg = config.opt.gnome.ui.wallpaper;
in
{
  options = with lib; {
    opt.gnome.ui.wallpaper = {
      default.enable = mkEnableOption "default GNOME wallpaper";
    };
  };

  config = {
    dconf.settings =
      { }
      // lib.optionalAttrs cfg.default.enable {
        "org/gnome/desktop/background" = {
          picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
          picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.jpg";
          primary-color = "#3071AE";
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
          picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.jpg";
          primary-color = "#3071AE";
        };
      };
  };
}
