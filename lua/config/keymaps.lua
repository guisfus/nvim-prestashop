local map = vim.keymap.set

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Ventana izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ventana abajo" })
map("n", "<C-k>", "<C-w>k", { desc = "Ventana arriba" })
map("n", "<C-l>", "<C-w>l", { desc = "Ventana derecha" })

-- Buffers
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer siguiente" })
map("n", "<leader>bc", "<cmd>bdelete<cr>", { desc = "Cerrar buffer" })

-- Explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorador toggle" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", { desc = "Explorador focus" })
map("n", "<leader>fe", "<cmd>NvimTreeFindFile<cr>", { desc = "Explorador archivo actual" })

-- Search
map("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "Buscar archivos" })

map("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "Buscar texto" })

map("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "Buffers" })

map("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "Help tags" })

map("n", "<leader>fr", function()
	require("fzf-lua").oldfiles()
end, { desc = "Archivos recientes" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnóstico en línea" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Siguiente diagnóstico" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnóstico anterior" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnósticos" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Diagnósticos del buffer" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Símbolos" })
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP list" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })

-- Utilities
map("n", "<leader>fc", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Formatear" })
