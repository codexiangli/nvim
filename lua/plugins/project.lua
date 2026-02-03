return {
    -- 项目管理器
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern" },
                patterns = { ".git", "Makefile", "package.json", "pyproject.toml" },
            })
            vim.keymap.set('n', '<leader>pp', ':Telescope projects<CR>')
        end
    },
}
