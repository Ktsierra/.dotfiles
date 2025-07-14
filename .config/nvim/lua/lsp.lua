-- Disables the ugly black lsp loader that shows lua.ls, i already have mini-notify
vim.lsp.handlers['$/progress'] = function() end
