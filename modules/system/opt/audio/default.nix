{ lib, config, ... }:
let
  cfg = config.opt.system.audio;
in
{
  options = {
    opt.system.audio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
  };
}
