local M = {}

M.ensure_installed = {
  "bash", "c", "css", "html", "javascript", "json", "lua", "markdown", "markdown_inline",
  "query", "regex", "rust", "scss", "svelte", "toml", "tsx", "typescript",
  "typst", "vim", "vimdoc", "vue", "yaml",
}

function M.setup()
  -- Instalar parsers faltantes
  local installed = {}
  for _, p in ipairs(vim.api.nvim_get_runtime_file("parser/*.so", true)) do
    installed[vim.fn.fnamemodify(p, ":t:r")] = true
  end
  for _, parser in ipairs(M.ensure_installed) do
    if not installed[parser] then
      pcall(vim.cmd, "TSInstall! " .. parser)
    end
  end

  -- Treesitter nativo: highlight por filetype
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M
