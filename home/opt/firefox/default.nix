{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.firefox;
in
{
  imports = [
    ./themes/gnome
  ];

  options = {
    opt.firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Firefox";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.firefox;
        description = "Firefox package to use";
      };
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
