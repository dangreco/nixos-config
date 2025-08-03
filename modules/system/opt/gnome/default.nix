{ lib, config, ... }:
let
  cfg = config.opt.system.gnome;
in
{
  options = {
    opt.system.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
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
