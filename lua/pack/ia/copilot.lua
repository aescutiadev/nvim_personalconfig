vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
})

local function read_env(name)
  local value = os.getenv(name)
  if value then
    return value
  end
  local ok, fallback = pcall(function()
    return vim.env[name]
  end)
  return ok and fallback or nil
end

local api_key = read_env("IA_API_KEY")

local function api_endpoint()
  local url = read_env("IA_API_URL")
  if not url or url == "" then
    return nil
  end
  url = url:gsub("/+$", "")
  if url:match("/chat/completions$") then
    return url
  end
  return url .. "/chat/completions"
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec
    if spec and spec.name == "CopilotChat.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
      local dir = spec.path
      vim.system({ "make", "tiktoken" }, { cwd = dir }, function(out)
        if out.code ~= 0 then
          vim.schedule(function()
            vim.notify("CopilotChat: fallo al compilar tiktoken\n" .. (out.stderr or ""), vim.log.levels.WARN)
          end)
        end
      end)
    end
  end,
})

local copilot_opts = {
  -- Modelo por defecto
  model = "qwen3.6",
  temperature = 0.1,

  -- Herramientas de confianza automática (lectura, sin riesgo)
  trusted_tools = { "file", "glob", "grep" },

  window = {
    layout = "vertical",
    width = 0.4,
    border = "rounded",
    title = "🤖 Copilot Chat",
  },

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

  auto_insert_mode = true,
  auto_fold = true,

  headers = {
    user = "👤 Tú",
    assistant = "🤖 Copilot",
    tool = "🔧 Herramienta",
  },

  providers = {
    copilot = { disabled = true },
    github_models = { disabled = true },

    nan = {
      disabled = false,

      get_url = function(_)
        return api_endpoint()
      end,

      get_headers = function()
        assert(api_key, "IA_API_KEY no está definida en el entorno")
        return {
          ["Authorization"] = "Bearer " .. api_key,
          ["Content-Type"] = "application/json",
        }, nil -- sin expiración
      end,

      get_models = function(_)
        return {
          {
            id = "qwen3.6",
            name = "Qwen 3.6",
            max_input_tokens = 202144, -- contextWindow
            streaming = true,
            -- modalities: input [text, image] · output [text]
          },
          {
            id = "gemma4",
            name = "Gemma 4",
            max_input_tokens = 262144,
            streaming = true,
            -- modalities: input [text, image] · output [text]
          },
          {
            id = "deepseek-v4-flash",
            name = "DeepSeek V4 Flash",
            max_input_tokens = 750000,
            streaming = true,
            -- modalities: input [text] · output [text]
          },
        }
      end,

      prepare_input = function(...)
        return require("CopilotChat.config.providers").copilot.prepare_input(...)
      end,
      prepare_output = function(...)
        return require("CopilotChat.config.providers").copilot.prepare_output(...)
      end,

      resolve_model = function(_, model)
        return model
      end,

      get_info = function(_)
        return { "Provider personalizado 'nan' → https://api.nan.builders/v1" }
      end,
    },
  },
}

require("config.defer").run("copilot", function()
  require("CopilotChat").setup(copilot_opts)
end)

local map = Snacks.keymap.set

local function chat()
  return require("CopilotChat")
end

map("n", "<leader>aa", function()
  chat().toggle()
end, {
  desc = "AI Toggle",
})

map("n", "<leader>ao", function()
  chat().open()
end, {
  desc = "AI Open",
})

map("n", "<leader>ac", function()
  chat().close()
end, {
  desc = "AI Close",
})

map("n", "<leader>ax", function()
  chat().reset()
end, {
  desc = "AI Reset",
})

map("n", "<leader>as", function()
  chat().stop()
end, {
  desc = "AI Stop",
})

map("n", "<leader>am", "<cmd>CopilotChatModels<CR>", {
  desc = "AI Models",
})

map("n", "<leader>ap", function()
  chat().select_prompt()
end, {
  desc = "Prompt Actions",
})

map("n", "<leader>aS", function()
  vim.ui.input({ prompt = "Save Chat: " }, function(name)
    if name and name ~= "" then
      chat().save(name)
    end
  end)
end, {
  desc = "Save Chat",
})

map("n", "<leader>aq", function()
  vim.ui.input({ prompt = "Quick Chat: " }, function(input)
    if input and input ~= "" then
      require("CopilotChat").ask(input, { sticky = { '#selection' } })
    end
  end)
end, {
  desc = "Quick chat (buffer)",
})

map("n", "<leader>aL", function()
  chat().load()
end, {
  desc = "Load Chat",
})

map("x", "<leader>af", "<cmd>CopilotChatFix<CR>", {
  desc = "Fix Code",
})

map("x", "<leader>ae", "<cmd>CopilotChatExplain<CR>", {
  desc = "Explain Code",
})

map("x", "<leader>at", "<cmd>CopilotChatTests<CR>", {
  desc = "Generate Tests",
})

map("x", "<leader>ad", "<cmd>CopilotChatDocs<CR>", {
  desc = "Generate Docs",
})

map("x", "<leader>ar", "<cmd>CopilotChatReview<CR>", {
  desc = "Review Code",
})

map("x", "<leader>aO", "<cmd>CopilotChatOptimize<CR>", {
  desc = "Optimize Code",
})

map("x", "<leader>aC", "<cmd>CopilotChatCommit<CR>", {
  desc = "Optimize Code",
})
