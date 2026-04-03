local M = {}

function M.setup()
	require("bufferline").setup({
		options = {
			mode = "buffers",
			diagnostics = "nvim_lsp",
			separator_style = "slant",
			always_show_bufferline = false,
			show_buffer_close_icons = true,
			show_close_icon = false,

			offsets = {
				{
					filetype = "NvimTree",
					text = "Directory",
					highlight = "Directory",
					text_align = "left",
					separator = false,
				},
			},
		},
	})
end

return M
