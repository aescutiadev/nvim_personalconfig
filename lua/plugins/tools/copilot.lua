local prompts = {
  Concise = "Please rewrite the following text to make it more concise.",
  CreateAPost =
  "Please provide documentation for the following code to post it in social media, like Linkedin, it has be deep, well explained and easy to understand. Also do it in a fun and engaging way.",
  Documentation = "Please provide documentation for the following code.",
  DocumentationForGithub = "Please provide documentation for the following code ready for GitHub using markdown.",
  Explain = "Please explain how the following code works.",
  FixCode = "Please fix the following code to make it work as intended.",
  FixError = "Please explain the error in the following text and provide a solution.",
  ImproveNamings = "Please provide better names for the following variables and functions.",
  JsDocs = "Please provide JsDocs for the following code in english.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
  Review = "Please review the following code and provide suggestions for improvement.",
  Spelling = "Please correct any grammar and spelling errors in the following text.",
  Summarize = "Please summarize the following text.",
  SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
  SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
  Tests = "Please explain how the selected code works, then generate unit tests for it.",
  Wording = "Please improve the grammar and wording of the following text.",
}

local copilot_chat = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = {
          enabled = false, -- Disabled: using blink-cmp-copilot instead
        },
        filetypes = {
          lua = true,
          python = true,
          javascript = true,
          typescript = true,
          markdown = true,
          html = true,
          astro = true,
          css = true,
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    version = "^4",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatModels",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatCommit",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = function()
      local prefix = "<leader>a"
      return {
        { prefix .. "o", "<cmd>CopilotChatOpen<CR>",   desc = "Open Chat" },
        { prefix .. "c", "<cmd>CopilotChatClose<CR>",  desc = "Close Chat" },
        { prefix .. "t", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Chat" },
        { prefix .. "r", "<cmd>CopilotChatReset<CR>",  desc = "Reset Chat" },
        { prefix .. "s", "<cmd>CopilotChatStop<CR>",   desc = "Stop Chat" },
        {
          prefix .. "S",
          function()
            vim.ui.input({ prompt = "Save Chat: " }, function(input)
              if input and input ~= "" then
                require("CopilotChat").save(input)
              end
            end)
          end,
          desc = "Save Chat",
        },
        {
          prefix .. "L",
          function()
            local copilot_chat = require("CopilotChat")
            local path = copilot_chat.config.history_path
            local chats = require("plenary.scandir").scan_dir(path, { depth = 1, hidden = true })
            for i, chat in ipairs(chats) do
              chats[i] = chat:sub(#path + 2, -6)
            end
            vim.ui.select(chats, { prompt = "Load Chat: " }, function(selected)
              if selected and selected ~= "" then
                copilot_chat.load(selected)
              end
            end)
          end,
          desc = "Load Chat",
        },
        {
          prefix .. "p",
          function()
            require("CopilotChat").select_prompt({ selection = require("CopilotChat.select").buffer })
          end,
          desc = "Prompt actions (buffer)",
          mode = "n",
        },
        {
          prefix .. "p",
          function()
            require("CopilotChat").select_prompt({ selection = require("CopilotChat.select").visual })
          end,
          desc = "Prompt actions (visual)",
          mode = "v",
        },
        {
          prefix .. "q",
          function()
            vim.ui.input({ prompt = "Quick Chat: " }, function(input)
              if input and input ~= "" then
                require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
              end
            end)
          end,
          desc = "Quick Chat (buffer)",
          mode = "n",
        },
        {
          prefix .. "q",
          function()
            vim.ui.input({ prompt = "Quick Chat: " }, function(input)
              if input and input ~= "" then
                require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
              end
            end)
          end,
          desc = "Quick Chat (visual)",
          mode = "v",
        },
      }
    end,
    opts = {
      model = "claude-sonnet-4.6", -- Cambia a tu modelo preferido claude-sonnet-4.5
      prompts = prompts,
      system_prompt = [[
You are an expert in Clean Architecture, scalable software design, and high-performance systems programming. You specialize in HTML, CSS, Tailwind, JavaScript, TypeScript, React, Vue, Angular, Svelte, PHP, Python, Rust, SQL and NoSQL databases, and frameworks such as Next.js, NestJS, Nuxt, Adonis, Laravel, Django, and Node.js.
All solutions must follow SOLID principles, DRY practices, strict separation of concerns, and modular design. If you detect any violation of SOLID, architectural coupling, low cohesion, or duplicated logic, you must explicitly point it out and propose a refactor before or alongside the implementation.
Architectural decisions must follow explicit Clean Architecture layering:
- Domain: pure business rules, entities, value objects, domain services. No framework or infrastructure dependencies.
- Application: use cases, orchestration, DTOs, ports/interfaces.
- Data (Infrastructure): database access, external services, frameworks, persistence adapters.
- Presentation (optional): UI, controllers, transport layer, API handlers.
Dependencies must always point inward. The domain layer must remain framework-agnostic.
Whenever you provide implementation code, you must also provide corresponding tests whenever feasible. Prefer unit tests first, then integration tests where relevant. Testing is mandatory unless technically impossible. Use idiomatic testing tools per ecosystem (e.g., Jest/Vitest, PHPUnit, PyTest, Rust built-in test framework, etc.).
For Rust specifically, prioritize idiomatic ownership and borrowing, memory safety, concurrency correctness, zero-cost abstractions, trait-based design, and performance-aware architecture.
Explain tradeoffs clearly and justify design decisions. Avoid overengineering, but never compromise architectural integrity.
Maintain a professional, direct, and pragmatic tone aimed at intermediate and advanced developers.
All code comments must be written in English and reflect industry best practices.
      ]],
      headers = {
        user = "👤 You",
        assistant = "🤖 Copilot",
        tool = "🔧 Tool",
      },
      separator = "━━",
      auto_fold = true,
      -- MCPHub integration
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.copilot",
          opts = {
            make_request = true,
            attach = {
              on_chat_open = true,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
    end,
  }
}

return {
  copilot_chat,
}
