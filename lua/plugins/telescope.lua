return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",                    -- always get the latest stable
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",               -- compiles the native sorter (needs make + gcc/clang)
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = "move_selection_previous",  -- easier navigation
              ["<C-j>"] = "move_selection_next",
              ["<C-h>"] = "which_key",                -- show key help
            },
          },
          -- Optional: nicer layout
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          winblend = 0,
        },

        pickers = {
          find_files = {
            theme = "dropdown",
            hidden = true,          -- show dotfiles
          },
          live_grep = {
            theme = "ivy",
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      })

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      -- Your existing keymaps + a few very useful ones
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope: Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live Grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help Tags" })
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope: Old Files" })
      vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Telescope: Grep String under cursor" })
    end,
  },

  -- ui-select is now inside the main telescope block above (cleaner)
}
