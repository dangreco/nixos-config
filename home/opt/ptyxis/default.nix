{
  _,
  lib,
  config,
  ...
}:
let
  id = "ptyxis";
  pkg = "ptyxis";
  name = "ptyxis";
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
