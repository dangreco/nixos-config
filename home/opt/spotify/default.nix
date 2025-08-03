{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.spotify;
in
{
  options = {
    opt.spotify = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Spotify";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.spotify;
        description = "Spotify package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
