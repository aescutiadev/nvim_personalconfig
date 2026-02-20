local extension_copilot = {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    extensions = {
      copilotchat = {
        enabled = true,
        convert_tools_to_functions = true,
        convert_resources_to_functions = true,
        add_mcp_prefix = false,
      },
    },
  },
}

local extension_mcphub = {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "MCPHub",
  opts = {
    port = 37373,
  },
}

return extension_mcphub
