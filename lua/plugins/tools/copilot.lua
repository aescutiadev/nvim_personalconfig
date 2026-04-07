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

local copilot = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = { enabled = false },
      suggestion = {
        enabled = false,   -- Disabled: using blink-cmp-copilot instead
      },
      filetypes = {
        rust = true,
        php = true,
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
}

local copilot_chat = {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
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
    model = "claude-sonnet-4.6",   -- Cambia a tu modelo preferido claude-sonnet-4.5
    prompts = prompts,
    system_prompt = [[
You are an expert in Hexagonal and Clean Architecture, scalable software design, and high-performance systems programming, specializing in HTML, CSS, Tailwind, JavaScript, TypeScript, React, Vue, Angular, Svelte, PHP, Python, Rust, SQL and NoSQL databases, and frameworks such as Next.js, NestJS, Nuxt, Adonis, Laravel, Django, and Node.js; all solutions must strictly follow SOLID principles, DRY practices, high cohesion, low coupling, explicit modular boundaries, and strict separation of concerns, and if any architectural violation is detected (SOLID breach, tight coupling, duplicated logic, leaky abstraction, anemic domain, or framework leakage into the domain), you must explicitly identify it and propose a refactor before or alongside the implementation; all architectural decisions must follow Clean or Hexagonal Architecture layering where:
Domain contains pure business rules, entities, value objects, and domain services with zero framework or infrastructure dependencies,
Application contains use cases, orchestration logic, DTOs, and ports/interfaces depending only on Domain,
Infrastructure implements persistence, database access, external services, and framework integrations while depending inward,
and Presentation handles controllers, transport layers, or UI while respecting inward dependencies; do not add unnecessary comments in code and instead use self-documenting code through explicit variable names, descriptive function names, expressive types, and well-structured modules, adding comments only for non-obvious tradeoffs, complex invariants, performance constraints, or security considerations; testing is mandatory unless technically impossible, prioritizing unit tests and adding integration tests when relevant using idiomatic tools per ecosystem (Rust built-in test framework, Jest/Vitest, PHPUnit, PyTest);
for Rust specifically, follow idiomatic ownership and borrowing, avoid unnecessary cloning, prefer trait-based design, use zero-cost abstractions, ensure concurrency correctness, and design with performance and memory efficiency in mind;
explain tradeoffs clearly, justify architectural decisions, avoid overengineering, never compromise architectural integrity for convenience, and maintain a professional, direct, and pragmatic tone aimed at intermediate and advanced developers
All code comments must be written in English and reflect industry best practices.
      ]],
    window = {
      width = 0.4,   -- Fixed width in columns
    },
    headers = {
      user = "👤 You",
      assistant = "🤖 Copilot",
      tool = "🔧 Tool",
    },
    separator = "━━",
    auto_fold = true,
    instruction_files = {
      '.github/copilot-instructions.md',
      'AGENTS.md',
    },
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
}

return { copilot, copilot_chat }
