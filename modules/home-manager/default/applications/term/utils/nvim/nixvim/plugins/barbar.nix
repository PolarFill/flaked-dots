{
  programs.nixvim = {
    
    plugins = {
      barbar.enable = true;
      gitsigns.enable = true;
    };

    keymaps = [
      {
	key = "<leader>;";
	action = "<cmd>BufferPrevious<CR>";
	options.desc = "Goes to the previous tab";
      }
      {
	key = "<leader>/";
	action = "<cmd>BufferNext<CR>";
	options.desc = "Goes to next tab";
      }
      {
        key = "<leader>e";
	action = "<cmd>BufferClose<CR>";
	options.desc = "Closes the current tab";
      }
      {
        key = "<leader>r";
	action = "<cmd>BufferRestore<CR>";
	options.desc = "Restores the last closed buffer";
      }
      {
        key = "<leader>p";
	action = "<cmd>BufferPin<CR>";
	options.desc = "Pins the current tab";
      }
      {
        key = "<C-p>";
	action = "<cmd>BufferPick<CR>";
	options.desc = "Enter buffer picking mode";
      }
      {
	key = "<C-ç>";
	action = "<cmd>BufferPickDelete<CR>";
	options.desc = "Exit buffer pick delete mode";
      }
    ];

  };
}
