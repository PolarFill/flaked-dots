{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.os.fonts;
  in {
    options.nixosModules.default.os.fonts = {
      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Setups some fonts";
      };
    };

  config = lib.mkIf cfg.enable {

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-monochrome-emoji
      ( nerdfonts.override { fonts = [ "FiraCode" "0xProto" ]; } )
    ];

  };
}
