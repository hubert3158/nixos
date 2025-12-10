# Audio configuration (PipeWire)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.hardware.audio;
in
{
  options.modules.hardware.audio = {
    enable = lib.mkEnableOption "audio support via PipeWire";

    enableAlsa = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ALSA support";
    };

    enableAlsa32Bit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable 32-bit ALSA support";
    };

    enablePulse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable PulseAudio compatibility";
    };

    enableJack = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable JACK support";
    };
  };

  config = lib.mkIf cfg.enable {
    # Disable PulseAudio (we use PipeWire)
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = cfg.enableAlsa;
      alsa.support32Bit = cfg.enableAlsa32Bit;
      pulse.enable = cfg.enablePulse;
      jack.enable = cfg.enableJack;
    };

    environment.systemPackages = with pkgs; [
      pipewire
      pavucontrol
    ];
  };
}
