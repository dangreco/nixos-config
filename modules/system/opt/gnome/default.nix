{ lib, config, ... }:
let
  id = "gnome";
  name = "Gnome";
  cfg = config.opt.system.${id};
in
{
  options = {
    opt.system.${id} = {
      enable = lib.mkEnableOption name;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics.enable = true;
      brillo.enable = true;
    };

    services = {
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };
    };
  };
}
