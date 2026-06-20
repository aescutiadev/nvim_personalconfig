-- Parsers que no vienen incluidos por defecto en Neovim 0.12
-- (los más comunes —lua, c, vim, markdown, query— ya vienen bundled)
local ok_ts, nvim_ts = pcall(require, "nvim-treesitter")
if not ok_ts then
  vim.notify("nvim-treesitter not installed; skipping Treesitter setup", vim.log.levels.WARN)
  return
end

-- Parsers que no vienen incluidos por defecto en Neovim 0.12
nvim_ts.install({
  "javascript",
  "typescript",
  "tsx",
  "jsx",
  "python",
  "rust",
  "bash",
  "json",
  "yaml",
  "html",
  "css",
  "latex",
  "scss",
  "typst",
  "regex",
})

local ts_group = vim.api.nvim_create_augroup("native_treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  callback = function(args)
    if vim.b[args.buf].bigfile then
      return
    end

    -- Highlighting (ya lo tenés en autocmds.lua, podés mover esto acá)
    pcall(vim.treesitter.start, args.buf)

    -- Indentación basada en Treesitter (vía el plugin, el core no la trae)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

