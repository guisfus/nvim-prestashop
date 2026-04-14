local M = {}

local function path_ends_with(path, suffix)
	return path:sub(-#suffix) == suffix
end

function M.find_root(bufnr)
	local root = vim.fs.root(bufnr, { "composer.json" })
	if root then
		return root
	end

	root = vim.fs.root(bufnr, function(name, path)
		return (name == "config.inc.php" or name == "defines.inc.php") and path_ends_with(path, "/config")
	end)
	if root then
		return vim.fs.dirname(root)
	end

	root = vim.fs.root(bufnr, function(name, path)
		return name == "parameters.php" and path_ends_with(path, "/app/config")
	end)
	if root then
		return vim.fs.dirname(vim.fs.dirname(root))
	end
end

function M.root_dir(bufnr, on_dir)
	local root = M.find_root(bufnr)
	if root then
		on_dir(root)
	end
end

return M
