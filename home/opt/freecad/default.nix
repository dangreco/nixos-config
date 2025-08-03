{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.freecad;
in
{
  options = {
    opt.freecad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable FreeCAD";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.freecad;
        description = "FreeCAD package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
