local aucmd = vim.api.nvim_create_autocmd

-- Highlight text when copied
aucmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Relative numbers depending on Insert mode
aucmd("InsertEnter", {
	callback = function()
		vim.opt_local.relativenumber = false
	end,
})

aucmd("InsertLeave", {
	callback = function()
		vim.opt_local.relativenumber = true
	end,
})

-- Load treesitter in supported filetypes
aucmd("FileType", {
	pattern = {
		"bash",
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"lua",
		"markdown",
		"php",
		"scss",
		"toml",
		"yaml",
	},
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Use indent based on treesitter in some filetypes
aucmd("FileType", {
	pattern = {
		"css",
		"html",
		"javascript",
		"json",
		"lua",
		"php",
		"scss",
	},
	callback = function(args)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
