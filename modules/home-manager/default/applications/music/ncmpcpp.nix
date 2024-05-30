{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.music.ncmpcpp;
  in {
    options.homeModules.default.applications.music.ncmpcpp = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Sets up the ncmpcpp tui mpd player!";
      };

    };

  config = lib.mkIf cfg.enable {   

    programs.ncmpcpp = {
      enable = true;
      mpdMusicDir = "~/Music";
      package = ( pkgs.ncmpcpp.override { visualizerSupport = true; } );
      settings = {
        
	# MPD
	mpd_host = "127.0.0.1";
	mpd_port = "6600";
	empty_tag_color = "9";
	message_delay_time = "2";

        # FFT visualization
        visualizer_data_source = "/tmp/mpd.fifo";
	visualizer_output_name = "my_fifo";
	visualizer_in_stereo = "no";
	visualizer_type = "spectrum";
	visualizer_look = "+|";
	visualizer_spectrum_smooth_look = "yes";
	visualizer_fps = "144";

        # Progress bar
	progressbar_color = "53";
	progressbar_elapsed_color = "205";
        progressbar_look = "▄▄▁";

	# User interface
	user_interface = "alternative";
	alternative_ui_separator_color = "2";

	# Statusbar
	statusbar_color = "170";

        # Misc
        connected_message_on_startup = "no";
        external_editor = "nvim";
        
	# Text
	now_playing_prefix = "$b$(220)  $(2)";
        now_playing_suffix = "$/b$(2)";
        current_item_prefix = "$b$(205)  $/b$(2)";
        current_item_suffix = "$2";
        selected_item_prefix = "$(197)";
        selected_item_suffix = "$(83)";

      };
    };
  }; 
} 
