{
  _,
  lib,
  config,
  ...
}:
let
  id = "git";
  name = "git";
  cfg = config.opt.${id};
in
{
  options = {
    opt.${id} = {
      enable = lib.mkEnableOption name;
      package = lib.mkPackageOption _.pkgs.stable id { };

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
