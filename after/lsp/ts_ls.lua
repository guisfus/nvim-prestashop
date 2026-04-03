local function path_exists(path)
	return path and vim.uv.fs_stat(path) ~= nil
end

local function find_global_npm_root()
	if vim.fn.executable("npm") ~= 1 then
		return nil
	end

	local result = vim.system({ "npm", "root", "-g" }, { text = true }):wait()
	if result.code ~= 0 then
		return nil
	end

	local root = vim.trim(result.stdout or "")
	if root == "" then
		return nil
	end

	return root
end

local function resolve_vue_language_server(root_dir)
	if root_dir then
		local local_server = vim.fs.find("node_modules/@vue/language-server", {
			path = root_dir,
			upward = true,
			type = "directory",
		})[1]

		if path_exists(local_server) then
			return local_server
		end
	end

	local npm_root = find_global_npm_root()
	if not npm_root then
		return nil
	end

	local global_server = npm_root .. "/@vue/language-server"
	if path_exists(global_server) then
		return global_server
	end

	return nil
end

local function build_vue_plugin(root_dir)
	local vue_language_server_path = resolve_vue_language_server(root_dir)
	if not vue_language_server_path then
		return nil
	end

	return {
		name = "@vue/typescript-plugin",
		location = vue_language_server_path,
		languages = { "vue" },
		configNamespace = "typescript",
	}
end

return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	},
	before_init = function(_, config)
		local vue_plugin = build_vue_plugin(config.root_dir)
		config.init_options = config.init_options or {}
		config.init_options.plugins = vue_plugin and { vue_plugin } or {}
	end,
}
