--[[
-- Neovim Initial Setup using lazy.nvim
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Sets up neovim options (vim.o and vim.opt)
require 'opt'
-- require 'completion'

-- Sets up keymaps
require 'keymaps'

-- Sets up autocommands ( like highlight on yank)
require 'autocommands'

-- Sets up commands (like :W for :w)
require 'commands'

-- Sets up plugins using lazy.nvim
require 'lazy-setup'
