local package_info = {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "BufRead package.json",
  opts = {},
}
local tsc = {
  "dmmulroy/tsc.nvim",
  cmd = "TSC",
  opts = {},
}

return { package_info, tsc }
