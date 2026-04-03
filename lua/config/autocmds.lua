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
		"blade",
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
		"typescript",
		"typescriptreact",
		"vue",
		"yaml",
	},
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Use indent based on treesitter in some filetypes
aucmd("FileType", {
	pattern = {
		"blade",
		"css",
		"html",
		"javascript",
		"json",
		"lua",
		"php",
		"scss",
		"typescript",
		"vue",
	},
	callback = function(args)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
