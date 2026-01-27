{
  programs.nixvim.plugins.harpoon = {
    enable = true;
    enableTelescope = true;
  };

  # harpoon2: keymaps must be defined at the top-level `keymaps` option.
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>ha";
      action.__raw = "function() require'harpoon':list():add() end";
    }
    {
      mode = "n";
      key = "<C-e>";
      action.__raw =
        "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
    }
    {
      mode = "n";
      key = "<leader>hj";
      action.__raw = "function() require'harpoon':list():select(1) end";
    }
    {
      mode = "n";
      key = "<leader>hk";
      action.__raw = "function() require'harpoon':list():select(2) end";
    }
    {
      mode = "n";
      key = "<leader>hl";
      action.__raw = "function() require'harpoon':list():select(3) end";
    }
    {
      mode = "n";
      key = "<leader>hm";
      action.__raw = "function() require'harpoon':list():select(4) end";
    }
  ];
}
