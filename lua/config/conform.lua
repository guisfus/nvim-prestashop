local M = {}

function M.setup()
	require("conform").setup({
		formatters = {
			pint = {
				command = function(ctx)
					local local_pint = vim.fs.find("vendor/bin/pint", {
						upward = true,
						path = ctx.dirname,
					})[1]

					if local_pint then
						return local_pint
					end

					return "pint"
				end,
				args = { "$FILENAME" },
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

			php = { "pint" },
		},

		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	})
end

return M
