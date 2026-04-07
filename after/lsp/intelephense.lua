return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_dir = require("config.lsp.prestashop_root"),
	settings = {
		intelephense = {
			telemetry = {
				enabled = false,
			},
		},
	},
}
