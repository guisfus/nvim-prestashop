return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_markers = { "composer.json", "artisan", ".git" },
	settings = {
		intelephense = {
			telemetry = {
				enabled = false,
			},
		},
	},
}
