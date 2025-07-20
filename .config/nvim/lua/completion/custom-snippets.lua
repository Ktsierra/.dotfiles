local M = {}

function M.add_snippets()
  local ls = require 'luasnip'
  local s = ls.snippet
  local i = ls.insert_node
  local t = ls.text_node
  local rep = require('luasnip.extras').rep

  local cl_snippet = s('cl', {
    t "console.log('",
    rep(1),
    t ":', ",
    i(1, ''),
    t ')',
  })

  ls.add_snippets(nil, {
    javascript = { cl_snippet },
    typescript = { cl_snippet },
    javascriptreact = { cl_snippet },
    typescriptreact = { cl_snippet },
  })
end
return M
