# Home-manager modules

This directory contains some nix modules aimed at modularizing home-manager. 
Something similar is avaible for system-level configuration (configuration.nix) at ../nixos

## Usage

You can just define a parameter pointing to the path in your outputs, like:
```
# Example taken from my flake.nix
homeModules.default = "${self}/modules/home-manager/default";
nixosModules.default = "${self}/modules/nixos/default";
```
After this, you can just import this param from the flake.nix into your desired file:
```
# Extracted from systems/nagisa/home.nix file
  imports = [
    outputs.homeModules.default
    # ...
  ];

  homeModules.default = {
    shell.fish.enable = true;
    # ...
  };
```
Keep in mind you also need to make your outputs referenceable as well. Check my flake.nix to see how.

## Folder hierarchy

```
# default.nix files excluded

nixos  # Contains system-level configuration (nvidia, pipewire, etc)
home-manager  # Contains user-level configuration (applications, wm, etc)
   default  # Default "family" of modules*
     shell  # Contains shell configurations and some basic shell-related applications (bat, gping, exa, etc)
     system  # Contains more "fundamental" parts of the system, which are still configured at user-level (ex: hyprland)
     misc  # No category
     applications  # Contains applications (duh)
       web  # Web-related applications
       social  # Applications related to socialization (ex: discord)
       term  # Terminal-related
```

*I've made this just to future-proof this system in case i wanted to specify a completely different configuration without overriding the existing one. A family of modules is just a set of specific configurations for certain applications. You can think of them like different rices for a system, which you can change very easily by just specifying which of the families you want to import.

## Conclusion

Feel free to use this system lol :p
