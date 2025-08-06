{
  _,
  lib,
  config,
  ...
}:
let
  id = "firefox";
  name = "Firefox";
  cfg = config.opt.${id};
in
{
  imports = [
    ./themes/gnome
  ];

  options = {
    opt.${id} = {
      enable = lib.mkEnableOption name;
      package = lib.mkPackageOption _.pkgs.stable id { };

      languagePacks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "en_CA" ];
        description = "Firefox language packs to use";
      };
    };
  };

  config =
    (lib.mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        package = cfg.package;
        languagePacks = cfg.languagePacks;
      };
    })
    // { };
}
