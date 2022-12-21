require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  --function(term)
    --if term.direction == "horizontal" then
      --return 15
    --elseif term.direction == "vertical" then
      --return vim.o.columns * 0.4
    --end
  --end,
  size = 75,
  open_mapping = [[<A-\>]],
  direction = 'vertical',
  --on_open = fun(t: Terminal), -- function to run when the terminal opens
  --on_close = fun(t: Terminal), -- function to run when the terminal closes
  hide_numbers = true, -- hide the number column in toggleterm buffers
  --shade_filetypes = {},
  --shade_terminals = true,
  --shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  --start_in_insert = true,
  --insert_mappings = true, -- whether or not the open mapping applies in insert mode
  --terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  --persist_size = true,
  --close_on_exit = true, -- close the terminal window when the process exits
  --shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  --float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    --border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    --width = <value>,
    --height = <value>,
    --winblend = 3,
    --highlights = {
    --  border = "Normal",
    --  background = "Normal",
    --}
  --}
}
