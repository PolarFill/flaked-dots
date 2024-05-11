{
    description = " Main config file ";

    inputs = {
        
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        
	home-manager = {
            url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
	};

        arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
	
	nur.url = "github:nix-community/NUR";
	
	chaotic-cx = {
          url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
	  inputs.nixpkgs.follows = "nixpkgs";
	};

	sops-nix.url = "github:Mic92/sops-nix";

        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
	
	hyprland-contrib = {
          url = "github:hyprwm/contrib";
          inputs.nixpkgs.follows = "nixpkgs";
        };     
#	hyprlang = {
#          url = "github:hyprwm/hyprlang";
	  # inputs.nixpkgs.follows = "hyprland";
#	};
	hyprland-plugins = {
          url = "github:hyprwm/hyprland-plugins";
	  inputs.hyprland.follows = "hyprland";
	};
#	hyprfocus = {
#          Broken
#          url = "github:pyt0xic/hyprfocus";
#          inputs.hyprland.follows = "hyprland";
#	};
	hyprland-virtual-desktops = {
          url = "github:levnikmyskin/hyprland-virtual-desktops";
	  inputs.nixpkgs.follows = "hyprland";
	};
        hyprland-portal = {
          url = "github:hyprwm/xdg-desktop-portal-hyprland";
	};
};

    outputs = { self, nixpkgs, home-manager, chaotic-cx, nur, ... } @ inputs:

    let

      inherit (self) outputs;
      systems = [ "x86_64-linux" ];                    # Only x86_64 for now
      withAllSystems = nixpkgs.lib.genAttrs systems;   # Will gen attrs for each specified system

      nagisaSysPath = "${self}/systems/nagisa";

    in {
   
      customPkgs = withAllSystems ( system: import ./overlays/pkgs nixpkgs.legacyPackages.${system} ); # Access custom pkgs (if any)
      formatter = withAllSystems ( system: nixpkgs.legacyPackages.${system}.alejandra );      # Not using currently, keeping it just in case

      overlays = import ./overlays { inherit inputs; };
      homeModules.default = "${self}/modules/home-manager/default";
      nixosModules.default = "${self}/modules/nixos/default";

      nixosConfigurations = {
        
	nagisa = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
	    modules = [
                "${nagisaSysPath}/configuration.nix"
		"${nagisaSysPath}/hardware-configuration.nix"
                nur.nixosModules.nur
		chaotic-cx.nixosModules.default
		home-manager.nixosModules.home-manager {
                  home-manager = {
                      useGlobalPkgs = true;
		      useUserPackages = true;
		      extraSpecialArgs = { inherit inputs outputs; };
		      users = { skynet = import "${nagisaSysPath}/home.nix"; };
		  }; 
		}
	      ];
	    };
          };
        };
}
