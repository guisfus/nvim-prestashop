local M = {}

function M.setup()
	require("conform").setup({
		formatters = {
			php_cs_fixer = {
				command = function(ctx)
					local local_php_cs_fixer = vim.fs.find("vendor/bin/php-cs-fixer", {
						upward = true,
						path = ctx.dirname,
					})[1]

					if local_php_cs_fixer then
						return local_php_cs_fixer
					end

					return "php-cs-fixer"
				end,
				args = { "fix", "$FILENAME" },
				stdin = false,
			},
		},

		formatters_by_ft = {
			lua = { "stylua" },

			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },

			css = { "prettier" },
			scss = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },

			php = { "php_cs_fixer" },
		},

		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	})
end

return M
