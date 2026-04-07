local function path_ends_with(path, suffix)
	return path:sub(-#suffix) == suffix
end

local function find_root(bufnr)
	local root = vim.fs.root(bufnr, { "composer.json", "artisan", ".git" })
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

return function(bufnr, on_dir)
	local root = find_root(bufnr)
	if root then
		on_dir(root)
	end
end
