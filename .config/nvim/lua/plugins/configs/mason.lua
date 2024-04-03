local options = {
  ensure_installed = {

    "lua-language-server",
    "stylua",
    "prettier",
    "html-lsp",
    "css-lsp",

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

  }, -- not an option from mason.nvim

  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

return options
