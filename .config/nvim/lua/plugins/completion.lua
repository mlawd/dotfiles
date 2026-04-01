return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  opts = {
    -- Use super-tab preset: Tab/S-Tab to navigate and accept.
    -- Avoids all Ctrl-based keymaps that zellij would intercept.
    keymap = { preset = "super-tab" },
    appearance = {
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
  },
}
