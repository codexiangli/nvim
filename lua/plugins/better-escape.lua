return {
    -- 使用 lazy.nvim 安装
    {
        'jdhao/better-escape.nvim',
        event = 'InsertEnter',
        config = function()
            require('better_escape').setup({
                mapping = { 'jk', 'kj' },  -- 多个映射
                timeout = 300,             -- 超时时间
                clear_empty_lines = false, -- 是否清除空行
                keys = '<Esc>',            -- 要发送的键
            })
        end,
    },
}
