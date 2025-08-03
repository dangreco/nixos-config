{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.ptyxis;
in
{
  options = {
    opt.ptyxis = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable ptyxis";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.ptyxis;
        description = "ptyxis package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
