{ lib, config, ... }:
let
  id = "plymouth";
  name = "Plymouth";
  cfg = config.opt.system.${id};
in
{
  options = {
    opt.system.${id} = {
      enable = lib.mkEnableOption name;
      luks.enable = lib.mkEnableOption "${name} LUKS support";
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
