return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_dir = require("config.lsp.prestashop_root").root_dir,
	settings = {
		intelephense = {
			telemetry = {
				enabled = false,
			},
		},
	},
}
