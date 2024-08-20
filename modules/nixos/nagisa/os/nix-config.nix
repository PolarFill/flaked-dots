{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.nixosModules.nagisa.os.nix-config;
in {
  options.nixosModules.nagisa.os.nix-config = {
    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.bool;
      description = "Configures nix-related stuff";
    };
  };

config = lib.mkIf cfg.enable {

  # Add flake inputs as registrys for use on nix3 shell
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  nix.settings = {
    trusted-users = [ "root" "skynet" ];
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    substituters = [
        "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  nixpkgs = {
    overlays = [
      inputs.nvidia-patch.overlays.default
#      outputs.overlays.additions
#      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  environment.shellAliases = {
    nixos-update-unl = "nixos-rebuild switch --flake .#nagisa --option eval-cache false --show-trace -v --use-remote-sudo";
    nixos-test-unl = "nixos-rebuild test --flake .#nagisa --option eval-cache false --show-trace -v --use-remote-sudo";
    nixos-test = "nixos-rebuild switch --flake .#nagisa --option eval-cache false --show-trace -v --max-jobs 1 --use-remote-sudo";
    nixos-update = "nixos-rebuild switch --flake .#nagisa --option eval-cache false --show-trace -v --max-jobs 1 --use-remote-sudo";
  };

};
}
