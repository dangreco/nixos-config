{ lib, config, ... }:
let
  cfg = config.opt.gnome.shortcuts;
  enumerate =
    list:
    builtins.genList (i: {
      index = i;
      value = builtins.elemAt list i;
    }) (builtins.length list);
in
{
  options = with lib; {
    opt.gnome.shortcuts = {
      desktop = {
        show = mkOption {
          type = types.str;
          default = "<Super>d";
        };
      };

      window = {
        center = mkOption {
          type = types.str;
          default = "<Super>c";
        };
        close = mkOption {
          type = types.str;
          default = "<Super>q";
        };
      };

      custom = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              name = mkOption {
                type = types.str;
              };
              command = mkOption {
                type = types.str;
              };
              binding = mkOption {
                type = types.str;
              };
            };
          }
        );
        default = [ ];
      };
    };
  };

  config =
    let
      bindings = enumerate cfg.custom;
    in
    {
      dconf.settings = {
        "org/gnome/desktop/wm/keybindings" = {
          move-to-center = lib.gvariant.mkArray [ cfg.window.center ];
          close = lib.gvariant.mkArray [ cfg.window.close ];
          show-desktop = lib.gvariant.mkArray [ cfg.desktop.show ];
        };
      }
      // builtins.listToAttrs (
        builtins.map (b: {
          name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString b.index}";
          value = b.value;
        }) bindings
      )
      // lib.optionalAttrs (builtins.length bindings != 0) {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = lib.gvariant.mkArray (
            builtins.map (
              b: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString b.index}/"
            ) bindings
          );
        };
      };
    };
}
