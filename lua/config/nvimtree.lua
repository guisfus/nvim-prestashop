local M = {}

function M.setup()
	require("nvim-tree").setup({
		sort_by = "name",

		view = {
			width = 34,
			side = "left",
			preserve_window_proportions = true,
		},

		renderer = {
			group_empty = true,
			highlight_git = true,
			highlight_opened_files = "name",
			icons = {
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
				},
			},
		},

		filters = {
			dotfiles = false,
			git_ignored = false,
		},

		git = {
			enable = true,
			ignore = false,
		},

		diagnostics = {
			enable = true,
			show_on_dirs = true,
		},

		update_focused_file = {
			enable = true,
			update_root = false,
		},
	})
end

return M
