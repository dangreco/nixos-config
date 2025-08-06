{
  _,
  lib,
  config,
  ...
}:
let
  id = "openscad";
  pkg = "openscad";
  name = "OpenSCAD";
  cfg = config.opt.${id};
in
{
  options = {
    opt.${id} = {
      enable = lib.mkEnableOption name;
      package = lib.mkPackageOption _.pkgs.stable pkg { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
