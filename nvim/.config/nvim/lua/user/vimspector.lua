vim.g.vimspector_sidebar_width = 40 --Default: 50
vim.g.vimspector_bottombar_height = 10 --default: 10
vim.g.vimspector_code_minwidth = 40 --default: 82
vim.g.vimspector_terminal_maxwidth = 80 --default: 80
vim.g.vimspector_terminal_minwidth = 20 --default: 10
vim.g.vimspector_enable_mappings = "VISUAL_STUDIO"

-- vim.g.vimspector_base_dir= "/home/linus/.config/nvim/vimspector-config"
vim.cmd("let g:vimspector_base_dir=expand( '$HOME/.config/nvim/vimspector-config' )")
