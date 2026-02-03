return {
    -- ============ 编辑增强 ================
    {
        "tpope/vim-commentary",
        config = function()
            vim.keymap.set('n', 'gcc', ':Commentary<CR>')
            vim.keymap.set('v', 'gc', ':Commentary<CR>')
        end
    },
}
