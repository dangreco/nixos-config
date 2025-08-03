{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.gnome;
in
{
  options = {
    opt.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Gnome settings";
      };

      features = {
        fractionalScaling = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        variableRefreshRate = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      ui = {
        battery = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        buttons = lib.mkOption {
          type = lib.types.str;
          default = ":minimize,maximize,close";
        };
      };

      shortcuts = {
        desktop = {
          show = lib.mkOption {
            type = lib.types.str;
            default = "<Super>d";
          };
        };
        window = {
          center = lib.mkOption {
            type = lib.types.str;
            default = "<Super>c";
          };
          close = lib.mkOption {
            type = lib.types.str;
            default = "<Super>q";
          };
        };

        custom = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                };
                command = lib.mkOption {
                  type = lib.types.str;
                };
                binding = lib.mkOption {
                  type = lib.types.str;
                };
              };
            }
          );
          default = [ ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        show-battery-percentage = cfg.ui.battery;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = cfg.ui.buttons;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        power-saver-profile-on-low-battery = true;
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.gvariant.mkUint32 0;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = false;
      };
      "org/gnome/mutter" = {
        experimental-features = lib.gvariant.mkArray (
          [ ]
          ++ lib.optionals cfg.features.fractionalScaling [ "scale-monitor-framebuffer" ]
          ++ lib.optionals cfg.features.variableRefreshRate [ "variable-refresh-rate" ]
        );
      };
      "org/gnome/desktop/wm/keybindings" = {
        move-to-center = lib.gvariant.mkArray [ cfg.shortcuts.window.center ];
        close = lib.gvariant.mkArray [ cfg.shortcuts.window.close ];
        show-desktop = lib.gvariant.mkArray [ cfg.shortcuts.desktop.show ];
      };
    }
    // _.lib.mkKeyBindings cfg.shortcuts.custom;
  };
}
