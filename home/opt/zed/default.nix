{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.zed;
in
{
  options = {
    opt.zed = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Zed";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.zed-editor;
        description = "Zed package to use";
      };
      extensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Zed extensions to install";
      };
      settings = {
        font = {
          ui = {
            size = lib.mkOption {
              type = lib.types.int;
              default = 16;
            };
          };
          buffer = {
            size = lib.mkOption {
              type = lib.types.int;
              default = 16;
            };
          };
        };
        theme = {
          ui = {
            light = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            dark = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
          };
          icon = {
            light = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            dark = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = cfg.package;
      extensions = cfg.extensions;
      userSettings = {
        ui_font_size = cfg.settings.font.ui.size;
        buffer_font_size = cfg.settings.font.buffer.size;
      }
      // (with cfg.settings.theme.ui; {
        theme = {
          mode = "system";
        }
        // (lib.optionalAttrs (light != null) { inherit light; })
        // (lib.optionalAttrs (dark != null) { inherit dark; });
      })
      // (with cfg.settings.theme.icon; {
        icon_theme = {
          mode = "system";
        }
        // (lib.optionalAttrs (light != null) { inherit light; })
        // (lib.optionalAttrs (dark != null) { inherit dark; });
      });
    };
  };
}
