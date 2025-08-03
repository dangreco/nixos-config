{ lib, config, ... }:
let
  cfg = config.opt.system.plymouth;
in
{
  options = {
    opt.system.plymouth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      luks.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config =
    (lib.mkIf cfg.enable {
      boot.plymouth.enable = true;
    })
    // (lib.mkIf (cfg.enable && cfg.luks.enable) {
      boot = {
        consoleLogLevel = 3;
        initrd.verbose = false;
        initrd.systemd.enable = true;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];
      };
    });
}
