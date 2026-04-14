return {
	cmd = { "twiggy-language-server", "--stdio" },
	filetypes = { "twig" },
	root_dir = require("config.lsp.prestashop_root").root_dir,
}
