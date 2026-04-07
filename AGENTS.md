Neovim 0.12.0 was released on March 29, 2026. This release adds a built-in plugin manager, expands built-in LSP support, introduces native insert-mode auto-completion, improves the default UI and statusline, adds several useful Lua APIs, and includes a number of breaking changes that may require config updates.

This guide is organized around the changes that matter most in day-to-day use, with practical examples and a short migration checklist at the end.

At a glance
The most important additions in 0.12 are:

Built-in plugin management with vim.pack

Expanded built-in LSP support, including selectionRange, inlineCompletion, linkedEditingRange, documentLink, and viewport-only semantic tokens

Native insert-mode auto-completion via the new 'autocomplete' option

A redesigned experimental core UI (ui2)

New commands such as :restart, :connect, and :uniq

Useful new Lua APIs such as vim.net.request(), vim.fs.ext(), vim.list.unique(), and vim.list.bisect()

Built-in plugins such as :Undotree and :DiffTool

Breaking changes around diagnostics, Treesitter behavior, and renamed APIs

Official source: :help news-0.12.

1. Built-in plugin manager: vim.pack
Neovim 0.12 adds vim.pack, a built-in plugin manager. It is still marked experimental, but the official docs describe it as stable enough for daily use.

Basic usage
vim.pack.add({
  'https://github.com/sainnhe/gruvbox-material',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  {
    src = 'https://github.com/neovim/nvim-lspconfig',
    version = 'v2.0.0',
  },
})
You can also use a table to set the plugin name explicitly:

vim.pack.add({
  {
    src = 'https://github.com/user/generic-name',
    name = 'my-plugin',
  },
})
Where plugins live
vim.pack manages plugins in a dedicated directory under your data path:

site/pack/core/opt
It also maintains a lockfile at:

~/.config/nvim/nvim-pack-lock.json
That lockfile should be treated like part of your config and kept under version control.

Updating plugins
vim.pack.update()
By default, this opens a confirmation buffer where you can review pending changes.

Useful variants:

vim.pack.update({ 'nvim-treesitter' })
vim.pack.update(nil, { force = true })
vim.pack.update(nil, { offline = true })
vim.pack.update(nil, { target = 'lockfile' })
Deleting plugins
vim.pack.del({ 'old-plugin' })
Important caveats
vim.pack uses Git and expects plugin sources to be Git repositories.

It is not a lazy-loading framework.

During init.lua sourcing, plugin loading defaults differently than after startup, so read :help vim.pack if you rely on exact loading behavior.

If a plugin is already on disk, vim.pack.add() does not automatically verify that its current revision matches the declared version; use vim.pack.update() to synchronize.

Events
PackChangedPre and PackChanged can be used for post-install or post-update hooks:

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
  end,
})
2. LSP improvements
Neovim 0.12 expands built-in LSP support significantly.

Native config and enable flow
The recommended built-in pattern is:

vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
}

vim.lsp.enable('lua_ls')
You can check whether it is attached with:

:checkhealth vim.lsp
New defaults and built-in mappings
Neovim now provides these global LSP mappings by default:

gra → code actions

gri → implementations

grn → rename

grr → references

grt → type definition

grx → run codelens

gO → document symbols

Ctrl-S in Insert mode → signature help

gx also handles textDocument/documentLink when the server supports it.

Newly supported or improved capabilities
0.12 adds or improves support for:

textDocument/selectionRange

textDocument/inlineCompletion

textDocument/linkedEditingRange

textDocument/documentLink

textDocument/onTypeFormatting

textDocument/semanticTokens/range for viewport-only semantic tokens

workspace/codeLens/refresh

selectionRange fallback
If Treesitter is not active, visual-mode an / in selection falls back to LSP selectionRange.

Code lens and other features are not always on automatically
The docs explicitly note that some features may need to be enabled manually depending on your setup, including:

code lens

linked editing

inlay hints

inline completion

:lsp
Neovim 0.12 includes a built-in :lsp command for interactive client management.

3. Native insert-mode auto-completion
Neovim 0.12 adds the new 'autocomplete' option:

vim.o.autocomplete = true
This enables built-in insert-mode auto-completion without a third-party completion UI plugin.

Other completion-related additions
'complete' gained new flags:

F{func} → complete using a named function

F → complete using 'completefunc'

o → complete using 'omnifunc'

It also supports limiting matches per source:

vim.o.complete = ".^5,t^3,w"
Useful popup menu options:

vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 40
vim.o.completeopt = 'menu,menuone,noselect'
Note that nearest is now a valid completeopt behavior for proximity-based sorting.

4. UI changes
Experimental ui2
Neovim 0.12 introduces ui2, an experimental redesign of the core messages and command-line UI.

Enable it with:

require('vim._core.ui2').enable()
What it changes:

avoids many “Press ENTER” interruptions

avoids delays from warnings like W10

highlights the command line as you type

exposes the pager as a regular buffer + window

Because it is explicitly marked experimental, it is best treated as something to try, not something to assume is stable in every workflow yet.

:restart
:restart
This restarts Neovim and reattaches all UIs.

:connect
:connect /tmp/nvim.sock
This dynamically connects the current UI to a server address.

Busy status
The 'busy' buffer status is shown in the default statusline using the symbol ◐.

5. Default statusline improvements
The default statusline is more useful in 0.12 and can show:

diagnostic counts

progress/status information

busy state

terminal exit information

Two notable helpers are:

vim.diagnostic.status()
vim.lsp.status()
If you already maintain a custom statusline, these APIs make it easier to integrate built-in diagnostics and LSP progress.

6. New Lua APIs worth knowing
vim.net.request()
Neovim now includes a built-in HTTP helper:

local res = vim.net.request('https://api.github.com/repos/neovim/neovim')
print(res.body)
vim.fs.ext()
print(vim.fs.ext('init.lua'))       -- lua
print(vim.fs.ext('archive.tar.gz')) -- gz
vim.list.unique()
local deduped = vim.list.unique({ 1, 2, 2, 3, 1 })
vim.list.bisect()
local idx = vim.list.bisect({ 10, 20, 30, 40 }, 25)
Other useful Lua additions
vim.hl.range() now allows multiple timed highlights

vim.tbl_extend() and vim.tbl_deep_extend() can take a function as conflict behavior

vim.version.intersect() computes version-range intersections

Iter:take() and Iter:skip() can accept predicates

Iter:peek() works for all iterator types

Iter:unique() deduplicates iterator output

7. Built-in plugins
:Undotree
:packadd nvim.undotree
:Undotree
This adds a built-in visual undo-tree navigator.

:DiffTool
:packadd nvim.difftool
:DiffTool path/to/dir1 path/to/dir2
This compares directories and files.

tohtml is now opt-in
:packadd nvim.tohtml
:TOhtml
tohtml is no longer loaded by default.

8. Treesitter changes
Markdown highlighting by default
Treesitter-based Markdown highlighting is enabled by default.

Built-in incremental selection
Neovim 0.12 adds built-in node-based selection:

v then an → select outward

v then in → select inward

v then ]n → next sibling

v then [n → previous sibling

This is especially useful if you want structural selection without relying on extra plugins.

Breaking change: get_parser()
vim.treesitter.get_parser() no longer throws on failure. It now returns nil when it cannot create a parser.

Old assumption:

local parser = vim.treesitter.get_parser(bufnr)
Safer 0.12 pattern:

local parser = vim.treesitter.get_parser(bufnr)
if parser then
  -- use parser
end
9. Diagnostics changes
Major breaking change: diagnostic signs
Diagnostic signs can no longer be configured with :sign-define or sign_define().

You must configure them through vim.diagnostic.config().

Example:

local sev = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [sev.ERROR] = 'E',
      [sev.WARN]  = 'W',
      [sev.INFO]  = 'I',
      [sev.HINT]  = 'H',
    },
  },
})
Other diagnostic notes
vim.diagnostic.disable() and vim.diagnostic.is_disabled() were removed

the legacy signature of vim.diagnostic.enable() is no longer supported

vim.diagnostic.status() is useful for statuslines

10. New editor commands and behaviors
New commands
:restart → restart Neovim and reattach UIs

:connect {addr} → connect current UI to a server

:iput → like :put, but adjusts indent

:retab -indentonly → retab only leading whitespace

:uniq → deduplicate lines in the current buffer

:wall ++p → write all buffers and create missing parent directories

:help! → help lookup with smarter guessing

:source with a range can detect Lua
When a selected range contains a Lua code block, Neovim can detect and execute it as Lua.

Search completion
'wildchar' now enables completion in search contexts such as /, ?, :g, :v, and :vimgrep.

11. Changed defaults
Some defaults changed in 0.12:

'shelltemp' now defaults to false

'diffopt' now includes improved defaults such as indent-heuristic and inline:char

'shada' excludes /tmp/ and /private/ paths by default

terminal 'scrollback' maximum increased to 1,000,000

Insert-mode Ctrl-R changed
Ctrl-R in Insert mode now inserts register contents literally by default.

If you relied on the older behavior that interpreted special characters, you may need to adjust your workflow.

12. Terminal improvements
Neovim 0.12 improves terminal behavior in several ways:

support for synchronized output (DEC private mode 2026)

support for clearing terminal scrollback via CSI 3 J

nvim_open_term() can now be called on a non-empty buffer

suspended PTY processes are shown as [Process suspended] and can be resumed by keypress

13. Notable new highlight groups and events
Highlight groups
Examples include:

DiffTextAdd

OkMsg

StderrMsg

StdoutMsg

SnippetTabstopActive

PmenuBorder

PmenuShadow

New events
Examples include:

CmdlineLeavePre

MarkSet

SessionLoadPre

TabClosedPre

PackChangedPre

PackChanged

14. Breaking changes and migration checklist
These are the items most likely to affect existing configs or plugins.

Rename changes
vim.diff → vim.text.diff

semantic tokens start()/stop() usage moved to enable()

Diagnostics
remove any :sign-define-based diagnostic sign setup

move diagnostic sign configuration to vim.diagnostic.config()

stop using removed functions like vim.diagnostic.disable()

Treesitter
update code that assumes vim.treesitter.get_parser() throws on failure

Plugins
tohtml is now opt-in

old shellmenu plugin is removed

Providers
Python 3.7 and 3.8 support were dropped

Options and behavior
'shelltemp' changed to false

Insert-mode Ctrl-R now inserts register contents literally

15. Practical 0.12 config examples
Minimal modern structure
~/.config/nvim/
├── init.lua
├── nvim-pack-lock.json
└── lua/
    └── config/
        ├── init.lua
        ├── options.lua
        ├── keymaps.lua
        ├── diagnostics.lua
        ├── autocmds.lua
        └── pack.lua
init.lua
require('config')
lua/config/init.lua
require('config.options')
require('config.pack')
require('config.keymaps')
require('config.diagnostics')
require('config.autocmds')
lua/config/options.lua
vim.o.autocomplete = true
vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 40
vim.o.completeopt = 'menu,menuone,noselect,nearest'
lua/config/diagnostics.lua
local sev = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = true,
  },
  signs = {
    text = {
      [sev.ERROR] = 'E',
      [sev.WARN]  = 'W',
      [sev.INFO]  = 'I',
      [sev.HINT]  = 'H',
    },
  },
})
lua/config/pack.lua
vim.pack.add({
  'https://github.com/sainnhe/gruvbox-material',
  'https://github.com/nvim-treesitter/nvim-treesitter',
})
16. What you can probably remove from your config
After upgrading to 0.12, you may be able to simplify your setup by removing or rethinking:

custom diagnostic-sign definitions based on :sign-define

manual statusline diagnostic counters

ad-hoc HTTP wrappers for simple requests

third-party undotree plugins if the built-in one is enough

plugin-manager bootstrap code if you switch to vim.pack

Whether you should remove nvim-lspconfig or a third-party completion plugin depends on how much custom behavior you want. Neovim 0.12 reduces the need for them, but it does not automatically make them obsolete for every workflow.

Bottom line
Neovim 0.12 is a substantial release, but the most important story is not just new features. It is that more of the editor is now usable without a large stack of plugins.

The biggest practical wins are:

vim.pack for built-in plugin management

stronger built-in LSP support

native insert-mode auto-completion

cleaner diagnostics configuration

useful built-in UI and Lua improvements

If you upgrade, the first places to review are your plugin manager, diagnostic sign config, Treesitter parser assumptions, and any code that still uses renamed APIs.

References
:help news-0.12

:help vim.pack

:help lsp

:help diagnostic-signs

:help ui2

:help deprecated-0.12