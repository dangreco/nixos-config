{ lib, config, ... }:
let
  cfg = config.opt.gnome.features;
in
{
  options = with lib; {
    opt.gnome.features = {
      fractionalScaling = {
        enable = mkEnableOption "fractional scaling";
      };
      variableRefreshRate = {
        enable = mkEnableOption "variable refresh rate";
      };
    };
  };

  config = {
    dconf.settings = {
      "org/gnome/mutter" = {
        experimental-features = lib.gvariant.mkArray (
          [ ]
          ++ lib.optionals cfg.fractionalScaling.enable [ "scale-monitor-framebuffer" ]
          ++ lib.optionals cfg.variableRefreshRate.enable [ "variable-refresh-rate" ]
        );
      };
    };
  };
}
