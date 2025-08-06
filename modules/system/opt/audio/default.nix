{ lib, config, ... }:
let
  id = "audio";
  name = "audio";
  cfg = config.opt.system.${id};
in
{
  options = {
    opt.system.${id} = {
      enable = lib.mkEnableOption name;
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
