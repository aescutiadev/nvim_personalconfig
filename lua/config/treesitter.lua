-- Parsers que no vienen incluidos por defecto en Neovim 0.12
-- (los más comunes —lua, c, vim, markdown, query— ya vienen bundled)
local parsers = {
  "javascript",
  "astro",
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
}

local ok_ts, nvim_ts = pcall(require, "nvim-treesitter")
if not ok_ts then
  vim.notify("nvim-treesitter not installed; skipping Treesitter setup", vim.log.levels.WARN)
  return
end

-- Instalar en cada arranque es trabajo que ya está hecho: sólo tiene sentido
-- cuando el plugin se instala o se actualiza.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec
    if spec and spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.schedule(function()
        require("nvim-treesitter").install(parsers)
      end)
    end
  end,
})

local ts_group = vim.api.nvim_create_augroup("native_treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  callback = function(args)
    if vim.b[args.buf].bigfile then
      return
    end

    -- Sólo si hay parser: setear el indentexpr de nvim-treesitter en un filetype
    -- sin parser rompe la indentación nativa y agrega trabajo por buffer.
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end

    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
