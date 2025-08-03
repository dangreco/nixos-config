{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.prusaslicer;
in
{
  imports = [
    ./printers/elrond
  ];

  options = {
    opt.prusaslicer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable PrusaSlicer";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.prusa-slicer;
        description = "PrusaSlicer package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
