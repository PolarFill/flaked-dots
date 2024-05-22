# Nixos dotfiles

This repository contains all of my nixos-related dotfiles. It's as reproducible as possible and extremely modular, with a very cool system to declare modules, while not being complex to the point of unreadability :D.

You're free to study and/or use these dotfiles in your system as you wish! A few caveats follow, however:

- Don't expect to use these configs "raw". These are **my** config files, adapted to my tastes, hardware, and needs.
- These config files aren't really adaptable, as in config params to define things. Most things are hardcoded.
- There isn't much automation. For example, when adding new modules, you need to edit the various "default.nix" files one by one.

## Documentation

While these dotfiles don't have that many comments for now (big mistake of mine), i try to document how things work in README files.

NixOS is a fantastic piece of software that, sadly, suffers from bad documentation. I gathered knowledge from lots of different places and, while i don't have a phd on nix, i learned quite a few things, things that were represented in these dotfiles.

I hope you can learn something, if you want, with these config files.

## Usage

- Clone the repository with ```git clone  https://github.com/polarfill/flaked-dots.git```
- Cd to flaked-dots folder
- Run ```nixos-rebuild  switch --flake .#<system_name>```
- That's it!

Additionaly, you can just run ```nixos-rebuild switch --flake github:polarfill/flaked-dots .#<system_name>```, but, as said, before, you probably want to change some things beforehand.

If you read all this rambling till here, hope you have a great day! (or night, whatever). 
