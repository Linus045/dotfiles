return {


	-- CMake integration
	"cdelledonne/vim-cmake",
	-- Tetris
	-- :Tetris
	"alec-gibson/nvim-tetris",

	-- use nvim in browser textedits (requires same browser plugin)
	-- use({
	--   "glacambre/firenvim",
	--   run = function()
	--     if first_install then return end
	--     vim.fn["firenvim#install"](0)
	--   end,
	-- })

	-- open markdown preview
	-- " normal/insert
	-- <Plug>MarkdownPreview
	-- <Plug>MarkdownPreviewStop
	-- <Plug>MarkdownPreviewToggle
	{
		"iamcco/markdown-preview.nvim",
		build = function() vim.fn["mkdp#util#install"]() end,
		config = function()
			vim.g.mkdp_filetypes = { "markdown", "vimwiki" }
		end,
		ft = { "markdown", "vimwiki" },
	},


	-- vim wiki
	{
		"vimwiki/vimwiki",
		config = function()
			vim.cmd(
				"let g:vimwiki_list = [{'path': '~/.nvim_journal/', 'path_html': '~/.nvim_journal/wiki_html/', 'index': '.nvim_journal', 'syntax': 'markdown', 'ext': '.md'}]")
		end
	},

	'jbyuki/instant.nvim',

	-- Latex plugins
	{
		"lervag/vimtex",
		lazy = false,
		config = function()
			-- This is necessary for VimTeX to load properly. The "indent" is optional.
			-- Note that most plugin managers will do this automatically.
			--vim.cmd("filetype plugin indent on");

			-- This enables Vim's and neovim's syntax-related features. Without this, some
			-- VimTeX features will not work (see ":help vimtex-requirements" for more
			-- info).
			--syntax enable

			-- Viewer options: One may configure the viewer either by specifying a built-in
			-- viewer method:
			vim.g.vimtex_view_method = "zathura"

			-- Or with a generic interface:
			vim.g.vimtex_view_general_viewer = 'zathura'
			vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

			-- VimTeX uses latexmk as the default compiler backend. If you use it, which is
			-- strongly recommended, you probably don't need to configure anything. If you
			-- want another compiler backend, you can change it as follows. The list of
			-- supported backends and further explanation is provided in the documentation,
			-- see ":help vimtex-compiler".
			--  vim.g.vimtex_compiler_progname = 'nvr'
			-- vim.g.vimtex_compiler_method = 'latexrun'
			vim.g.vimtex_compiler_latexrun = {
				out_dir = 'build_latexrun',
				aux_dir = 'build_latexrun',
			}
			vim.g.vimtex_compiler_latexmk = {
				out_dir = 'build_latexmk',
				aux_dir = 'build_latexmk',
			}


			-- Most VimTeX mappings rely on localleader and this can be changed with the
			-- following line. The default is usually fine and is the symbol "\".
			-- let maplocalleader = --,"


			-- focus pdf viewer on sucessful compilation
			-- vim.api.nvim_create_autocmd({ "User" }, {
			-- 	pattern = { "VimtexEventCompileSuccess" },
			-- 	callback = function(ev)
			-- 		vim.cmd("VimtexView")
			-- 		-- vim.cmd [[call b:vimtex.viewer.xdo_focus_vim()]]
			-- 	end
			-- })
		end
	},

	{
		'JellyApple102/easyread.nvim',
		config = function()
			require('easyread').setup({
				fileTypes = { "text" },
			})
		end
	},

	-- {
	-- 	"giusgad/pets.nvim",
	-- 	dependencies = {
	-- 		"giusgad/hologram.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("pets").setup({
	-- 			row = 5,                 -- the row (height) to display the pet at (higher row means the pet is lower on the screen), must be 1<=row<=10
	-- 			col = 0,                 -- the column to display the pet at (set to high number to have it stay still on the right side)
	-- 			speed_multiplier = 1,    -- you can make your pet move faster/slower. If slower the animation will have lower fps.
	-- 			default_pet = "dog",     -- the pet to use for the PetNew command
	-- 			default_style = "brown", -- the style of the pet to use for the PetNew command
	-- 			random = false,          -- wether to use a random pet for the PetNew command, ovverides default_pet and default_style
	-- 			death_animation = true,  -- animate the pet's death, set to false to feel less guilt -- currently no animations are available
	-- 			popup = {
	-- 				width = "100%",        -- can be a string with percentage like "45%" or a number of columns like 45
	-- 				winblend = 100,        -- winblend value - see :h 'winblend' - only used if avoid_statusline is false
	-- 				hl = { Normal = "Normal" }, -- hl is only set if avoid_statusline is true, you can put any hl group instead of "Normal"
	-- 				avoid_statusline = false, -- if winblend is 100 then the popup is invisible and covers the statusline, if that
	-- 				-- doesn't work for you then set this to true and the popup will use hl and will be spawned above the statusline (hopefully)
	-- 			}
	-- 		})

	-- 		-- plugin is not supported inside a tmux session (currently)
	-- 		if os.getenv("TMUX") == nil then
	-- 			-- spawn pet on startup
	-- 			vim.cmd "PetsNewCustom dog beige Dog1"
	-- 		end
	-- 	end
	-- },

	-- {
	-- 	"tamton-aquib/zone.nvim",
	-- 	config = function()
	-- 		require("zone").setup({
	-- 			style = "vanish",
	-- 			after = 60,
	-- 		})
	-- 	end
	-- },

	-- :CellularAutomaton make_it_rain
	-- :CellularAutomaton game_of_life
	{
		"eandrju/cellular-automaton.nvim"
	}

}
