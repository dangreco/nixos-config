{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.fish;
in
{
  options = {
    opt.fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable fish";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.fish;
        description = "fish package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      package = cfg.package;
      shellAliases = {

      }
      // (if config.opt.zed.enable then { zed = "zeditor"; } else { });
    };
  };
}
