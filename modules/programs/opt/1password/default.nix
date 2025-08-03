{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.programs._1password;
in
{
  options = {
    opt.programs._1password = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      gui = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = _.pkgs.stable._1password-gui;
        };
      };
      cli = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = _.pkgs.stable._1password-cli;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs._1password-gui = {
      enable = cfg.gui.enable;
      package = cfg.gui.package;
    };
    programs._1password = {
      enable = cfg.cli.enable;
      package = cfg.cli.package;
    };
  };
}
