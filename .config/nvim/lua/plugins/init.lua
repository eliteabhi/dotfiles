return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {

        "lua-language-server", "stylua",
    		"html-lsp", "css-lsp" , "prettier",


        "deno",
        "typescript-language-server",

        "bash-language-server",
        "shellcheck",
        "shfmt",

        "python-lsp-server",
        "sourcery",
        "pylint",

        "asm-lsp",
        "asmfmt",

        "clangd",
        "clang-format",
        "cmake-language-server",
        "cmakelang",
        "codelldb",

        "cpplint",
        "cpptools",

        "arduino-language-server",

        "dockerfile-language-server",
        "docker-compose-language-service",

        "rust-analyzer",

        "sonarlint-language-server"

      },
    },
  }
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
