local neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",

  -- Keymaps
  keys = {
    {
      "<Leader>e",
      function()
        require("neo-tree.command").execute {
          toggle = true,
          position = "left",
          source = "filesystem",
          reveal = true,
        }
      end,
      desc = "Open Float Neotree",
    },
    {
      "<leader>bn",
      function()
        require("neo-tree.command").execute {
          toggle = true,
          position = "left",
          source = "buffers",
          reveal = true,
        }
      end,
      desc = "Neotree buffers",
    },
    {
      "<leader>bN",
      function()
        require("neo-tree.command").execute {
          toggle = true,
          position = "float",
          source = "buffers",
          reveal = true,
        }
      end,
      desc = "Neotree buffers",
    },
    {
      "<Leader>o",
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.wincmd("p")
        else
          vim.cmd.Neotree("focus")
        end
      end,
      desc = "Toggle Neo-tree Focus",
    },
    {
      "<Leader><space>",
      function()
        require("neo-tree.command").execute {
          toggle = true,
          position = "float",
          source = "filesystem",
          reveal = true,
        }
      end,
      desc = "Open Float Neotree",
    },
  },

  opts = function()
    local git_available = vim.fn.executable("git") == 1

    -- Función helper para iconos (usando Nerd Fonts)
    local function get_icon(name)
      local icons = {
        -- Folds
        FoldClosed   = "",
        FoldOpened   = "",

        -- Folders
        FolderClosed = "",
        FolderOpen   = "",
        FolderEmpty  = "",

        -- Files
        DefaultFile  = "󰈙",
        FileModified = "●",

        -- Git
        GitAdd       = "",
        GitDelete    = "",
        GitChange    = "",
        GitRenamed   = "➜",
        GitUntracked = "★",
        GitIgnored   = "◌",
        GitUnstaged  = "✗",
        GitStaged    = "✓",
        GitConflict  = "",
        Git          = "󰊢",

        -- Diagnostics
        Diagnostic   = "󰒡",
      }
      return icons[name] or ""
    end

    local sources = {
      { source = "filesystem",  display_name = get_icon("FolderClosed") .. " File" },
      { source = "buffers",     display_name = get_icon("DefaultFile") .. " Bufs" },
      { source = "diagnostics", display_name = get_icon("Diagnostic") .. " Diagnostic" },
    }

    if git_available then
      table.insert(sources, 3, { source = "git_status", display_name = get_icon("Git") .. " Git" })
    end

    return {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = git_available,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },

      sources = {
        "filesystem",
        "buffers",
        git_available and "git_status" or nil,
      },

      source_selector = {
        winbar = true,
        statusline = false,
        content_layout = "center",
        tabs_layout = "equal",
        show_separator_on_edge = false,
        sources = sources,
      },

      default_component_configs = {
        container = { enable_character_fade = true },
        indent = {
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = get_icon("FoldClosed"),
          expander_expanded = get_icon("FoldOpened"),
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = get_icon("FolderClosed"),
          folder_open = get_icon("FolderOpen"),
          folder_empty = get_icon("FolderEmpty"),
          folder_empty_open = get_icon("FolderEmpty"),
          default = get_icon("DefaultFile"),
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = get_icon("FileModified"),
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = get_icon("GitAdd"),
            deleted = get_icon("GitDelete"),
            modified = get_icon("GitChange"),
            renamed = get_icon("GitRenamed"),
            untracked = get_icon("GitUntracked"),
            ignored = get_icon("GitIgnored"),
            unstaged = get_icon("GitUnstaged"),
            staged = get_icon("GitStaged"),
            conflict = get_icon("GitConflict"),
          },
        },
      },

      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.ui.open(path)
        end,

        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,

        child_or_open = function(state)
          local node = state.tree:get_node()
          if node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              if node.type == "file" then
                state.commands.open(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          else
            state.commands.open(state)
          end
        end,

        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))

          if vim.tbl_isempty(options) then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end

          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },

      window = {
        position = "left",
        width = 30,
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          ["<space>"] = { "toggle_node", nowait = false },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          ["l"] = "child_or_open",
          ["h"] = "parent_or_close",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["a"] = { "add", config = { show_path = "none" } },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
          ["i"] = "show_file_details",
          ["Y"] = "copy_selector",
          ["O"] = "system_open",
        },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
        },
      },

      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = true,
          hide_by_name = { "node_modules" },
          hide_by_pattern = { "*.meta", "*/src/*/tsconfig.json" },
          always_show = { ".env", ".gitignored" },
          never_show = { ".DS_Store", "thumbs.db" },
          never_show_by_pattern = { ".null-ls_*" },
        },
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "fuzzy_sorter",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["og"] = { "order_by_git_status", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },

      buffers = {
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },

      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },

      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.relativenumber = false
            vim.opt_local.number = false
            vim.opt_local.signcolumn = "no"
            vim.opt_local.foldcolumn = "0"
          end,
        },
        {
          event = "file_opened",
          handler = function() end,
        },
      },
    }
  end,

  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("neotree_start", { clear = true }),
      desc = "Open Neo-tree when entering a directory",
      once = true,
      callback = function(args)
        if package.loaded["neo-tree"] then
          return
        end
        local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if stats and stats.type == "directory" then
          require("lazy").load({ plugins = { "neo-tree.nvim" } })
        end
      end,
    })
  end,
}

local fileOperations = {
  "antosha417/nvim-lsp-file-operations",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neo-tree/neo-tree.nvim",
  },
  config = function()
    require("lsp-file-operations").setup()
  end,
}

local windowPicker = {
  "s1n7ax/nvim-window-picker",
  version = "2.*",
  config = function()
    require("window-picker").setup({
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        bo = {
          filetype = { "neo-tree", "neo-tree-popup", "notify" },
          buftype = { "terminal", "quickfix" },
        },
      },
    })
  end,
}

return { neotree, fileOperations, windowPicker }
