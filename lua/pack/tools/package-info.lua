vim.pack.add({
  "https://github.com/vuki656/package-info.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
})

-- Es información de versiones para package.json; en otro buffer no aporta nada.
require("config.defer").on_filetype("json", "package-info", function()
  require('package-info').setup()
end)
