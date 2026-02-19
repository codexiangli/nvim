-- Java 文件创建插件
return {
  'codexiangli/nvim-java-creator.nvim',
  dependencies = {
    'folke/snacks.nvim', -- 推荐的选择器
  },
  -- 只声明插件，不配置快捷键（在 ftplugin 中配置）
  ft = 'java', -- 仅在 Java 文件时懒加载
  cmd = {
    'JavaCreate',
    'JavaCreateClass',
    'JavaCreateTest',
    'JavaCreateInterface',
    'JavaCreateEnum',
  },
}