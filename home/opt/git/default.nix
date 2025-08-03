{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.git;
in
{
  options = {
    opt.git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Git";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.git;
        description = "Git package to use";
      };
      lfs.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Git LFS";
      };
      user = {
        name = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Git user string";
        };
        email = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Git user email";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = cfg.package;
      lfs.enable = cfg.lfs.enable;
    }
    // (if cfg.user.name != null then { userName = cfg.user.name; } else { })
    // (if cfg.user.email != null then { userEmail = cfg.user.email; } else { });
  };
}
