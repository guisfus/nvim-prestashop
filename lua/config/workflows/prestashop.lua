local M = {}

local helpers = require("config.workflows.helpers")

function M.is_active(context)
	local filetype = helpers.context_filetype(context)
	if vim.tbl_contains({ "smarty", "twig" }, filetype) then
		return true
	end

	return helpers.has_marker(context, {
		"config/config.inc.php",
		"config/defines.inc.php",
		"app/config/parameters.php",
	})
end

function M.filetypes()
	return {
		extension = {
			tpl = "smarty",
			twig = "twig",
		},
	}
end

function M.plugins()
	return {
		{ repo = "blueyed/smarty.vim" },
	}
end

function M.plugin_configs()
	return {}
end

function M.conform()
	return {
		formatters = {
			php_cs_fixer = {
				command = function(ctx)
					return helpers.resolve_local_or_global(ctx, "vendor/bin/php-cs-fixer", "php-cs-fixer")
				end,
				args = { "fix", "$FILENAME" },
				stdin = false,
			},
		},
		php_formatter = function(bufnr)
			local filename = vim.api.nvim_buf_get_name(bufnr)
			local dirname = vim.fs.dirname(filename)
			local conform = require("conform")

			if
				dirname
				and helpers.find_upward(dirname, {
					"config/config.inc.php",
					"config/defines.inc.php",
					"app/config/parameters.php",
				})
			then
				return { "php_cs_fixer" }
			end

			if conform.get_formatter_info("php_cs_fixer", bufnr).available then
				return { "php_cs_fixer" }
			end
		end,
	}
end

function M.register_lsps(activate, is_active)
	activate.register("html", "vscode-html-language-server", { "smarty" }, { should_enable = is_active })
	activate.register(
		"tailwindcss",
		"tailwindcss-language-server",
		{ "css", "scss", "javascript", "smarty", "twig" },
		{ should_enable = is_active }
	)
	activate.register(
		"twiggy-language-server",
		"twiggy-language-server",
		{ "twig" },
		{ notify_missing = false, should_enable = is_active }
	)
end

return M
