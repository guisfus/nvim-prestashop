local M = {}

function M.setup()
	local ok, ts = pcall(require, "nvim-treesitter")
	if not ok then
		vim.notify("nvim-treesitter is not available.", vim.log.levels.WARN)
		return
	end

	-- Config base for nvim-treesitter
	ts.setup({
		install_dir = vim.fn.stdpath("data") .. "/site",
	})

	-- Parsers
	ts.install({
		"bash",
		"css",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"php",
		"query",
		"scss",
		"toml",
		"vim",
		"vimdoc",
		"yaml",
	})
end

return M
