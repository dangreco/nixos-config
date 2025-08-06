{
  _,
  lib,
  config,
  ...
}:
let
  id = "prusaslicer";
  pkg = "prusa-slicer";
  name = "PrusaSlicer";
  cfg = config.opt.${id};
in
{
  imports = [
    ./printers/elrond
  ];

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
