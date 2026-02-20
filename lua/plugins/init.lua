local devicons = {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = {
    override_by_extension = {
      css = { icon = "󰌜", color = "#42a5f5", name = "Css" },
      postcss = { icon = "󰌜", color = "#e65100", name = "PostCss" },
    },
  },
}
local minicons = {
  "echasnovski/mini.icons",
  optional = true,
  opts = function(_, opts)
    if not opts.file then opts.file = {} end
    opts.file[".nvmrc"] = { glyph = "", hl = "MiniIconsGreen" }
    opts.file[".node-version"] = { glyph = "", hl = "MiniIconsGreen" }
    opts.file["package.json"] = { glyph = "", hl = "MiniIconsGreen" }
    opts.file["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" }
    opts.file["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" }
    opts.file["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" }
    if not opts.extension then opts.extension = {} end
    opts.extension["css"] = { glyph = "󰌜", hl = "MiniIconsBlue" }
    opts.extension["postcss"] = { glyph = "󰌜", hl = "MiniIconsOrange" }
    opts.file["postcss.config.js"] = { glyph = "󰌜", hl = "MiniIconsOrange" }
    opts.file["postcss.config.cjs"] = { glyph = "󰌜", hl = "MiniIconsOrange" }
    opts.file["postcss.config.mjs"] = { glyph = "󰌜", hl = "MiniIconsOrange" }
  end,
}

return {
  devicons,
  minicons,
}
