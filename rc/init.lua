-- vim: set ts=8 sts=2 sw=2 et fdm=marker fdl=1:

-- slice's neovim config (2021 lua rewrite) :] <o_/ <o_/
-- "dang, i've been using vim for 7 years" edition?
-- (requires neovim™ 0.5 or later)

-- be lazy {{{

local cmd = vim.cmd
local fn = vim.fn

local g = vim.g
local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- }}}

function greet()
  cmd [[echo "(>^_^>) ♥ ♥ ♥ (<^_^<)"]]
end

cmd [[command! Greet :lua greet()<CR>]]
greet()

-- options {{{

local scope_mapping = {global = o, buffer = bo, window = wo}

-- TODO: figure out if lua passes by value or not: it would be much cleaner if
--       we could just pass in the editor option tables directly
local function opt(key, value, scopes)
  if scopes == nil then
    scopes = {'global'}
  end

  if type(scopes) == 'string' then
    scopes = {scopes}
  end

  if not vim.tbl_contains(scopes, 'global') then
    -- XXX: if we haven't specified to affect global options, make sure
    --      to do so. until we get `vim.opt`, we have to do this.
    table.insert(scopes, 'global')
  end

  for _, scope_name in ipairs(scopes) do
    scope_mapping[scope_name][key] = value
  end
end

opt('colorcolumn', '80,120', 'window')
opt('completeopt', 'menuone,noselect')
opt('hidden', true)
opt('ignorecase', true)
opt('inccommand', 'nosplit')
opt('joinspaces', false)
opt('list', true, 'window')
opt('listchars', [[tab:> ,trail:·,nbsp:+]], 'window')
opt('modeline', true, 'buffer')
opt('mouse', 'a')
opt('swapfile', false, 'buffer')
-- i don't wanna wait too long for CursorHold, and since we aren't using
-- swapfiles we won't be hammering disk, either
opt('updatetime', 1000)
opt('wrap', false, 'window')
opt('number', true, 'window')
opt('relativenumber', true, 'window')
-- opt('scrolloff', 10)
opt('splitright', true)
opt('shortmess', o.shortmess .. 'I')
opt('smartcase', true)
opt('statusline', [[%f %r%m%=%l/%L,%c (%P)]], 'window')
opt('termguicolors', true)
opt('undodir', fn.stdpath('data') .. '/undo')
opt('undofile', true, 'buffer')
local blend = 5
opt('pumblend', blend) -- extremely important
opt('winblend', blend, 'window') -- ditto

opt('expandtab', true, 'buffer')
opt('tabstop', 8, 'buffer')
opt('softtabstop', 2, 'buffer')
opt('shiftwidth', 2, 'buffer')

-- }}}

-- TODO: here we assume that packer is installed, maybe gracefully fail if it
--       isn't?
cmd('packadd packer.nvim')

-- plugin options {{{

g.seoul256_background = 236
g.zenburn_old_Visual = true
g.zenburn_alternate_Visual = true

g.rooter_patterns = {'.git'}
g.rooter_manual_only = true
g.rooter_cd_cmd = 'lcd'

g.moonflyItalics = false

-- }}}

-- plugins {{{

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'justinmk/vim-dirvish'      -- improved builtin file browser
  use 'justinmk/vim-gtfo'         -- gof opens gui file manager
  use 'junegunn/vim-easy-align'   -- text alignment
  use 'tpope/vim-scriptease'      -- utilities for vim scripts
  use 'tpope/vim-eunuch'          -- vim sugar for unix shell commands
  use 'tpope/vim-commentary'      -- good comment editing
  use 'tpope/vim-unimpaired'      -- pairs of handy bracket mappings
  use 'tpope/vim-surround'        -- easily edit surrounding characters
  use 'tpope/vim-fugitive'        -- delightful git wrapper
  use 'tpope/vim-rhubarb'         -- github support for fugitive
  use 'tpope/vim-repeat'          -- . works on more stuff
  use 'tpope/vim-abolish'         -- better abbrevs, searching, etc.
  use 'sbdchd/neoformat'          -- asynchronous formatting
  use 'junegunn/vim-peekaboo'     -- peekaboo the registers
  use 'mhinz/vim-sayonara'        -- better :bd
  use 'Konfekt/vim-CtrlXA'        -- increased support for <C-X> & <C-A>
  use 'AndrewRadev/splitjoin.vim' -- splitting and joining stuff
  use 'airblade/vim-rooter'       -- cding to project roots
  use 'equalsraf/neovim-gui-shim' -- interact w/ neovim-qt
  -- use 'https://gitlab.com/code-stats/code-stats-vim.git'

  use { -- neovim lsp integration
    'neovim/nvim-lspconfig',
    requires = {{'nvim-lua/lsp_extensions.nvim'}},
    config = function()
      local nvim_lsp = require 'lspconfig'

      vim.cmd [[highlight! link LspDiagnosticsDefaultError ErrorMsg]]
      vim.cmd [[highlight! link LspDiagnosticsDefaultWarning Number]]

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          -- make warnings and errors appear over hints
          severity_sort = true
        }
      )

      local function map_buf(mode, key, result)
        vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true})
      end

      local function on_attach(client)
        vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        map_buf('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
        map_buf('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        map_buf('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        map_buf('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
        vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()]])
        if vim.api.nvim_buf_get_option(0, 'filetype') == 'rust' then
          vim.cmd([[autocmd BufEnter,BufWritePost <buffer> ]] ..
            [[:lua require('lsp_extensions.inlay_hints').request ]] ..
            [[{ prefix = ' :: ', enabled = {'ChainingHint', 'TypeHint', 'ParameterHint'}}]])
        end
      end

      nvim_lsp.rust_analyzer.setup {
        on_attach = on_attach,
        settings = {
          ['rust-analyzer'] = {
            assist = {
              importMergeBehavior = 'last',
              importPrefix = 'by_self'
            },
            cargo = {
              loadOutDirsFromCheck = true
            },
            procMacro = {
              enable = true
            }
          }
        }
      }
    end,
  }

  -- colorschemes
  local colorschemes = {
    'junegunn/seoul256.vim',
    'romainl/Apprentice',
    'nanotech/jellybeans.vim',
    'jnurmine/Zenburn',
    'wadackel/vim-dogrun',
    'bluz71/vim-moonfly-colors',
    'bluz71/vim-nightfly-guicolors',
    'arzg/vim-substrata',
    'vim-scripts/burnttoast256',
    'itchyny/landscape.vim',
    'baskerville/bubblegum'
  }
  for _, colorscheme in ipairs(colorschemes) do
    use {colorscheme, opt = true}
  end

  -- language support
  -- TODO: tree-sitter
  use 'Vimjas/vim-python-pep8-indent' -- better python indentation rules
  use 'ziglang/zig.vim'
  use 'derekwyatt/vim-scala'
  use 'rhysd/vim-crystal'
  use 'wavded/vim-stylus'
  use 'rust-lang/rust.vim'
  use 'fatih/vim-go'
  use 'pangloss/vim-javascript'       -- javascript
  -- use 'leafgarland/typescript-vim'  -- typescript (this one behaves weirdly)
  use 'HerringtonDarkholme/yats.vim'  -- typescript
  use 'MaxMEllon/vim-jsx-pretty'      -- jsx/tsx
  use 'neovimhaskell/haskell-vim'
  -- use 'keith/swift.vim'

  -- lua
  use { -- superduperfast colorizer
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }
  use { -- fuzzy finding of pretty much anything
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function()
      vim.cmd [[highlight! link TelescopeMatching MatchParen]]

      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          prompt_prefix = '? ',
          -- NOTE(slice): non-zero value makes the cursor invisible?
          winblend = 0,
          mappings = {
            i = {
              -- don't go into normal mode
              ["<esc>"] = actions.close
            }
          }
        }
      }
    end
  }
  use { -- quick terminals
    '~/src/prj/nvim-popterm.lua',
    config = function()
      local pt = require('popterm')
      pt.config.window_height = 0.8
      vim.cmd [[highlight! link PopTermLabel WildMenu]]
    end
  }
  use {
    'norcalli/snippets.nvim',
    config = function()
      require('snippets').snippets = {
        _global = {
          todo = 'TODO(slice): ',
          note = 'NOTE(slice): ',
          fixme = 'FIXME(slice): ',
          copy = '(c) slice ${=os.date("%Y")}',
          date = function() return os.date() end
        }
      }
    end
  }
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require('compe').setup {
        preselect = 'enable',
        source = {
          path = true,
          -- buffer = true,
          nvim_lsp = true,
          nvim_lua = true,
          snippets_nvim = true
        }
      }
    end
  }
end)

-- }}}

cmd('colorscheme bubblegum2')

-- maps {{{

g.mapleader = ' '

-- from: https://github.com/wbthomason/dotfiles/blob/5117f6d76c64baa661368e85a25ca463ff858a05/neovim/.config/nvim/lua/config/utils.lua
local function map(modes, lhs, rhs, opts)
  opts = opts or {}
  if opts.noremap == nil then
    opts.noremap = true
  end
  if type(modes) == 'string' then
    modes = {modes}
  end
  for _, mode in ipairs(modes) do
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

-- have i_CTRL-U make the previous word uppercase instead
map('i', '<c-u>', '<esc>gUiwea')

function POPTERM_TOGGLE()
  if IS_POPTERM() then
    -- if we're currently inside a popterm, just hide it
    POPTERM_HIDE()
  else
    POPTERM_NEXT()
  end
end

-- nvim-popterm.lua
map('n', '<a-tab>', '<cmd>lua POPTERM_TOGGLE()<CR>')
map('t', '<a-tab>', '<cmd>lua POPTERM_TOGGLE()<CR>')

-- cd to vcs root
map('n', '<leader>r', '<cmd>Rooter<CR>')

-- quickly open :terminals
map('n', '<leader>te', '<cmd>tabnew +terminal<CR>')
map('n', '<leader>ts', '<cmd>below split +terminal<CR>')
map('n', '<leader>tv', '<cmd>vsplit +terminal<CR>')

-- telescope
map('n', '<leader>o', '<cmd>Telescope find_files<CR>')
map('n', '<leader>i', '<cmd>Telescope oldfiles<CR>')
map('n', '<leader>b', '<cmd>Telescope buffers<CR>')
map('n', '<leader>qp', '<cmd>Telescope builtin<CR>')
map('n', '<leader>qg', '<cmd>Telescope live_grep<CR>')
map('n', '<leader>qf', '<cmd>Telescope file_browser hidden=true<CR>')
map('n', '<leader>qc', '<cmd>Telescope colorscheme<CR>')
map('n', '<leader>qs', '<cmd>Telescope filetypes<CR>')

-- vimrc; https://learnvimscriptthehardway.stevelosh.com/chapters/07.html
map('n', '<leader>ev', "bufname('%') == '' ? '<cmd>edit $MYVIMRC<CR>' : '<cmd>vsplit $MYVIMRC<CR>'", {expr = true})
map('n', '<leader>sv', '<cmd>luafile $MYVIMRC<CR>')

-- packer; formerly plug
-- XXX: not showing windows sometimes, bug?
map('n', '<leader>pi', '<cmd>PackerInstall<CR>')
map('n', '<leader>pu', '<cmd>PackerUpdate<CR>')
map('n', '<leader>ps', '<cmd>PackerSync<CR>')
map('n', '<leader>pc', '<cmd>PackerCompile<CR>')

-- neoformat
map('n', '<leader>nf', '<cmd>Neoformat<CR>')

-- align stuff easily
-- NOTE: need noremap=false because of <Plug>
map('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})
map('n', 'ga', '<Plug>(EasyAlign)', {noremap = false})

-- use <c-l> to hide highlights from searching
-- TODO: find a good plugin to do this automatically?
map('n', '<C-L>', '<cmd>nohlsearch<CR>')

-- Q enters ex mode by default, so let's bind it to gq instead
-- (as suggested by :h gq)
map('n', 'Q', 'gq', {noremap = false})

-- replace :bdelete with sayonara
map('c', 'bd', 'Sayonara!')

-- snippets.nvim
map('i', '<c-l>', "<cmd>lua return require'snippets'.expand_or_advance(1)<CR>")
map('i', '<c-h>', "<cmd>lua return require'snippets'.advance_snippet(-1)<CR>")

-- sometimes i hold down shift for too long >_>
local abbrevs = {
  W = 'w',
  Wq = 'wq',
  Q = 'q',
  Qa = 'qa',
  Bd = 'bd',
}

for lhs, rhs in pairs(abbrevs) do
  cmd(string.format('cabbrev %s %s', lhs, rhs))
end

-- maps so we can use :diffput and :diffget in visual mode
-- (can't use d because it means delete already)
map('v', 'fp', ":'<,'>diffput<CR>")
map('v', 'fg', ":'<,'>diffget<CR>")

-- }}}

-- autocmds {{{

-- from: https://github.com/wbthomason/dotfiles/blob/5117f6d76c64baa661368e85a25ca463ff858a05/neovim/.config/nvim/lua/config/utils.lua
local function aug(group, cmds)
  if type(cmds) == 'string' then
    cmds = {cmds}
  end
  cmd('augroup ' .. group)
  cmd('autocmd!') -- clear existing group
  for _, c in ipairs(cmds) do
    cmd('autocmd ' .. c)
  end
  cmd('augroup END')
end

-- personal colorscheme tweaks
aug('colorschemes', {
  'ColorScheme bubblegum-256-dark highlight Todo gui=bold'
    .. ' | highlight Folded gui=reverse'
    .. ' | highlight! link MatchParen LineNr'
})

-- highlight when yanking (built-in)
aug('yank', 'TextYankPost * silent! lua vim.highlight.on_yank()')

local lang_indent_settings = {
  go = {width = 4, tabs = true},
  scss = {width = 2, tabs = false},
  sass = {width = 2, tabs = false},
}

local language_settings_autocmds = {}
for extension, settings in pairs(lang_indent_settings) do
  local width = settings['width']

  local expandtab = 'expandtab'
  if settings['tabs'] then
    expandtab = 'noexpandtab'
  end

  local autocmd = string.format(
    'FileType %s setlocal tabstop=%d softtabstop=%d shiftwidth=%d %s',
    extension, width, width, width, expandtab
  )
  table.insert(language_settings_autocmds, autocmd)
end

vim.list_extend(language_settings_autocmds, {
  'BufNewFile,BufReadPre *.sc,*.sbt setfiletype scala',
  'BufNewFile,BufReadPre,BufReadPost *.ts,*.tsx setfiletype typescriptreact',
})

aug('language_settings', language_settings_autocmds)

-- hide line numbers in terminals
aug('terminal_numbers', 'TermOpen * setlocal nonumber norelativenumber')

-- automatically neoformat
-- TODO: use prettierd
local autoformat_extensions = {'js', 'css', 'html', 'yml', 'yaml'}
autoformat_extensions = table.concat(
  vim.tbl_map(function(ext) return '*.' .. ext end, autoformat_extensions),
  ','
)
aug(
  'autoformatting',
  'BufWritePre ' .. autoformat_extensions .. ' silent! undojoin | Neoformat'
)

aug(
  'packer',
  'User PackerCompileDone '
    .. 'echohl DiffAdd | '
    .. 'echomsg "... packer.nvim loader file compiled!" | '
    .. 'echohl None'
)

-- }}}

-- gui {{{

-- configure gui, neovim-qt is assumed to be used

function apply_gui_settings()
  -- TODO: make this compatible on other platforms
  -- XXX: this depends on neovim-gui-shim, see plugins section
  cmd [[Guifont! Fira Mono:h10.5]]
  cmd [[GuiScrollBar 1]]
  cmd [[GuiPopupmenu 0]]
end

-- make this a command for easy reinvocation :)
cmd('command! ApplyGUISettings :lua apply_gui_settings()<CR>')

-- XXX: it seems like Guifont only exists if we're in a GUI that supports it.
if vim.fn.exists('Guifont') then
  -- cmd [[echom "omg!"]]
  -- apply_gui_settings()
end

-- }}}
