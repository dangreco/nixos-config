{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.openscad;
in
{
  options = {
    opt.openscad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable OpenSCAD";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.openscad;
        description = "OpenSCAD package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
