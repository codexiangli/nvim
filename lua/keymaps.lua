vim.g.mapleader = " "
-- define common options

local opts = {

    noremap = true, -- non-recursive

    silent = true,  -- do not show message

}



-----------------

-- Normal mode --

-----------------



-- Hint: see `:h vim.map.set()`

-- Better window navigation

vim.keymap.set('n', '<C-h>', '<C-w>h', opts)

vim.keymap.set('n', '<C-j>', '<C-w>j', opts)

vim.keymap.set('n', '<C-k>', '<C-w>k', opts)

vim.keymap.set('n', '<C-l>', '<C-w>l', opts)


-- 自己添加的快捷键
vim.keymap.set('n', '<F2>', ':set invpaste<CR>', { silent = true, noremap = true })

-- lua 运行
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")


local bufopts = { noremap = true, silent = true, }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-S>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('i', '<C-S>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
end, bufopts)


-- Resize with arrows

-- delta: 2 lines

vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)

vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)

vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)

vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)



-----------------

-- Visual mode --

-----------------



-- Hint: start visual mode with the same area as the previous area and the same mode

vim.keymap.set('v', '<', '<gv', opts)

vim.keymap.set('v', '>', '>gv', opts)
