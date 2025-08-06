{
  _,
  lib,
  config,
  ...
}@inputs:
let
  id = "zed";
  pkg = "zed-editor";
  name = "Zed";
  cfg = config.opt.${id};
in
{
  options = {
    opt.${id} = {
      enable = lib.mkEnableOption name;
      package = lib.mkPackageOption _.pkgs.stable pkg { };

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

  config =
    let
      formatter = {
        binary = "nixfmt";
        arguments = [
          "--quiet"
          "--"
        ];
        package = _.pkgs.unstable.nixfmt;
      };

      lsps = import ./lsps.nix inputs;
    in
    lib.mkIf cfg.enable {
      home.packages =
        (with _.pkgs.stable; [
          nil
          nixd
        ])
        ++ [ formatter.package ]
        ++ lsps.packages;

      programs.zed-editor = {
        enable = true;
        package = cfg.package;
        extensions = cfg.extensions;
        userSettings = {
          ui_font_size = cfg.settings.font.ui.size;
          buffer_font_size = cfg.settings.font.buffer.size;

          lsp = {
            nil = {
              initialization_options = {
                formatting = {
                  command = [ "${formatter.package}/bin/${formatter.binary}" ] ++ formatter.arguments;
                };
              };
            };
            nixd = {
              initialization_options = {
                formatting = {
                  command = [ "${formatter.package}/bin/${formatter.binary}" ] ++ formatter.arguments;
                };
              };
            };
          }
          // lsps.config;
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
