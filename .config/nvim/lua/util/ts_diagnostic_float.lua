-- Custom diagnostic float for TypeScript/JavaScript files
-- Formats TS errors nicely and uses render-markdown.nvim for proper rendering

local M = {}

-- Cache namespace (created once at module load)
local ns = vim.api.nvim_create_namespace 'ts_diagnostic_float'

-- Filetypes where we use the custom float
local ts_filetypes = {
  typescript = true,
  typescriptreact = true,
  javascript = true,
  javascriptreact = true,
}

-- Pre-computed severity icons and highlights
local severity_icons = {
  [vim.diagnostic.severity.ERROR] = '󰅚 ',
  [vim.diagnostic.severity.WARN] = '󰀪 ',
  [vim.diagnostic.severity.INFO] = '󰋽 ',
  [vim.diagnostic.severity.HINT] = '󰌶 ',
}
local severity_hls = {
  [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
  [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
  [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
  [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
}

--- Format a TypeScript error message into markdown
---@param message string The raw error message
---@return string The formatted markdown message
local function format_ts_message(message)
  -- Try to use PrettyTsFormat from the rplugin if available
  local ok, formatted = pcall(vim.fn.PrettyTsFormat, message)
  if ok and formatted and formatted ~= '' then
    return formatted
  end
  -- Fallback: just return the original message
  return message
end

--- Get severity icon
---@param sev integer
---@return string
local function get_severity_icon(sev)
  return severity_icons[sev] or ' '
end

--- Get severity highlight group
---@param sev integer
---@return string
local function get_severity_hl(sev)
  return severity_hls[sev] or 'Normal'
end

--- Show custom diagnostic float for current line
function M.show()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  -- Use default float for non-TS/JS files
  if not ts_filetypes[ft] then
    vim.diagnostic.open_float()
    return
  end

  local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_row })

  if #diagnostics == 0 then
    return
  end

  -- Sort: tsserver first (higher priority), then others
  table.sort(diagnostics, function(a, b)
    local a_is_ts = a.source == 'tsserver' or a.source == 'typescript' or a.source == 'ts'
    local b_is_ts = b.source == 'tsserver' or b.source == 'typescript' or b.source == 'ts'
    if a_is_ts and not b_is_ts then
      return true
    end
    if b_is_ts and not a_is_ts then
      return false
    end
    -- Same source type, sort by severity
    return a.severity < b.severity
  end)

  -- Build markdown content
  local lines = {}
  local hl_ranges = {} -- Store highlight info for severity icons

  for i, diag in ipairs(diagnostics) do
    local source = diag.source or 'unknown'
    local is_ts = source == 'tsserver' or source == 'typescript' or source == 'ts'
    local message = diag.message

    -- Format TS messages, leave others as-is
    if is_ts then
      message = format_ts_message(message)
    end

    local icon = get_severity_icon(diag.severity)
    local code = diag.code and (' `' .. diag.code .. '`') or ''
    local header = icon .. '**' .. source .. '**' .. code

    -- Track line number for icon highlighting
    local header_line = #lines
    table.insert(hl_ranges, {
      line = header_line,
      col_start = 0,
      col_end = #icon,
      hl = get_severity_hl(diag.severity),
    })

    table.insert(lines, header)

    -- Add message lines
    for msg_line in message:gmatch '[^\n]+' do
      table.insert(lines, msg_line)
    end

    -- Add separator between diagnostics (except last)
    if i < #diagnostics then
      table.insert(lines, '')
      table.insert(lines, '---')
      table.insert(lines, '')
    end
  end

  -- Create buffer
  local float_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)

  -- Set buffer options
  vim.bo[float_buf].filetype = 'markdown'
  vim.bo[float_buf].bufhidden = 'wipe'
  vim.bo[float_buf].modifiable = false

  -- Calculate window size
  local max_width = 80
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(width + 2, max_width)
  local height = math.min(#lines, 20)

  -- Open float
  local win = vim.api.nvim_open_win(float_buf, false, {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set window options
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].conceallevel = 2
  vim.wo[win].concealcursor = 'nvic'

  -- Apply severity highlights to icons
  for _, hl_info in ipairs(hl_ranges) do
    vim.api.nvim_buf_add_highlight(float_buf, ns, hl_info.hl, hl_info.line, hl_info.col_start, hl_info.col_end)
  end

  -- Enable treesitter markdown highlighting
  vim.treesitter.start(float_buf, 'markdown')

  -- Use render-markdown.nvim for proper rendering (uses extmarks, not conceal)
  -- We need a slight delay to ensure treesitter is fully initialized
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(float_buf) and vim.api.nvim_win_is_valid(win) then
      local ok, api = pcall(require, 'render-markdown.api')
      if ok then
        -- Clear any existing state for this buffer
        local ui_ok, ui = pcall(require, 'render-markdown.core.ui')
        if ui_ok and ui.cache then
          ui.cache[float_buf] = nil
        end
        local state_ok, state = pcall(require, 'render-markdown.state')
        if state_ok and state.cache then
          state.cache[float_buf] = nil
        end
        -- Now render
        api.render { buf = float_buf, win = win }
      end
    end
  end, 10)

  -- Auto-close on cursor move
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave', 'WinLeave' }, {
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })
end

return M
