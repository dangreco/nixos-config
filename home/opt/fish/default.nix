{
  _,
  lib,
  config,
  ...
}:
let
  id = "fish";
  name = "fish";
  cfg = config.opt.${id};
in
{
  options = {
    opt.${id} = {
      enable = lib.mkEnableOption name;
      package = lib.mkPackageOption _.pkgs.stable id { };
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
