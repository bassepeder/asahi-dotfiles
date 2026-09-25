local servers = {
  vtsls = {
    settings = {
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "none" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = false },
          enumMemberValues = { enabled = true },
        },
      },
      completions = { completeFunctionCalls = true },
    },
  },
  rust_analyzer = {},
  clangd = {},
  cssls = {},
  html = {},
  oxlint = {
    settings = { fixKind = "all" },
  },
}
servers.vtsls.settings.javascript = servers.vtsls.settings.typescript

local capabilities = require("blink.cmp").get_lsp_capabilities()
for name, opts in pairs(servers) do
  opts.capabilities = capabilities
  vim.lsp.config(name, opts)
end
vim.lsp.enable(vim.tbl_keys(servers))

local function format(bufnr)
  bufnr = bufnr or 0
  local oxlint = vim.lsp.get_clients({ bufnr = bufnr, name = "oxlint" })[1]
  if oxlint then
    local done = false
    oxlint:exec_cmd({
      title = "Apply Oxlint automatic fixes",
      command = "oxc.fixAll",
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, { bufnr = bufnr }, function()
      done = true
    end)
    vim.wait(2000, function()
      return done
    end, 10)
  end
  vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 2000 })
end
_G.lsp_format = format

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    format(args.buf)
  end,
})

local metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  group = metals_group,
  callback = function()
    local metals = require("metals")
    local config = metals.bare_config()

    config.init_options.statusBarProvider = "on"
    config.settings = {
      serverVersion = "latest.snapshot",
      inlayHints = {
        byNameParameters = { enable = false },
        hintsInPatternMatch = { enable = false },
        implicitArguments = { enable = false },
        implicitConversions = { enable = false },
        inferredTypes = { enable = false },
        typeParameters = { enable = false },
      },
    }
    config.capabilities = capabilities

    metals.initialize_or_attach(config)
  end,
})
