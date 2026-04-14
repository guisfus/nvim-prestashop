return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"smarty",
		"twig",
	},
	root_dir = require("config.lsp.tailwind_root"),
}
