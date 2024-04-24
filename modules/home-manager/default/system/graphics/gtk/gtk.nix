# Since hm only supports setting themes from pkgs, we just do all of the process manually
# Gtk2 theme is set via its config in ~/.gtkc-2.0
# Gtk3 theme is set via its config in $XDG_CONFIG_HOME/gtk-3.0/settings.ini
# Gtk4 theme is set via a envvar (although you can also specify)
# Otherwise we're just symlinking themes/icons to its respective places

# TODO: Make icons, themes, and cursors opt-in or opt-out with options
# TODO: Make icons, themes, and cursors selectable (currently they're hardcoded)

{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.system.graphics.gtk;
  in {
    options.homeModules.default.system.graphics.gtk = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Set default system theme for gtk2/3";
      };
    };

  config = lib.mkIf cfg.enable {   

    gtk = {
      gtk3.extraConfig = {
        gtk-icon-theme-name = "rose-pine-icons";
	gtk-theme-name = "rose-pine-gtk";
      };
      gtk2.extraConfig =  ''
        gtk-icon-theme-name = "rose-pine-icons"
	gtk-theme-name = "rose-pine-gtk"
      '';
    };

    home.file = {
      rose-pine-theme = { 
        source = ./themes/gtk3/rose-pine;
	target = ".themes/";
      };
      rose-pine-icons = {
        source = ./icons/gtk3/rose-pine;
	target = ".icons/";
      };
      rose-pine-gtk-cursor = {
        source = ./cursors/rose-pine-gtk;
	target = ".local/share/icons/default"; # This makes the cursor the default one user-wide (for xcursor)
      };
    };

    home.sessionVariables = {
      GTK_THEME = "rose-pine-gtk";
    };

  };
}
