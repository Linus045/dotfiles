return {
	"kyazdani42/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local nvim_tree = require("nvim-tree")
		local nvim_tree_config = require("nvim-tree.config")
		local tree_cb = nvim_tree_config.nvim_tree_callback

		-- automatically open nvim-tree when vim starts
		local function open_nvim_tree(data)
			-- buffer is a [No Name]
			-- local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

			-- buffer is a directory
			local directory = vim.fn.isdirectory(data.file) == 1
			if not directory then
				return
			end

			-- create a new, empty buffer
			vim.cmd.enew()

			-- wipe the directory buffer
			vim.cmd.bw(data.buf)

			-- change to the directory
			vim.cmd.cd(data.file)

			-- open the tree
			require("nvim-tree.api").tree.open()
		end
		vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

		nvim_tree.setup({
			diagnostics = {
				enable = true,
			},
			update_focused_file = {
				enable = true,
			},
			view = {
				side = "left",
				mappings = {
					custom_only = false,
					list = {
						{ key = { "l", "<CR>" }, cb = tree_cb("edit") },
						{ key = "h",             cb = tree_cb("close_node") },
						{ key = { "s", "v" },    cb = tree_cb("vsplit") },
					},
				},
			},
			renderer = {
				root_folder_label = ":t",
				icons = {
					glyphs = {
						default = "",
						symlink = "",
						git = {
							unstaged = "",
							staged = "S",
							unmerged = "",
							renamed = "➜",
							deleted = "",
							-- untracked = "U",
							untracked = "★",
							ignored = "◌",
						},
					},
				},
			},
			actions = {
				open_file = {
					quit_on_open = true,
					resize_window = false,
				},
			},
		})
	end
}
