require("hoverhints").setup()
require("lsp-lens").setup()
require("tabout").setup()
require("codeium").setup()
require("ultimate-autopair").setup()
require("guess-indent").setup()
require("satellite").setup()

require("surround-ui").setup({
	root_key = "ys"
})

require("modes").setup()

require("hlchunk").setup({
	chunk = {
		style = {
			{ fg = "#a6e3a1" },
			{ fg = "#313244" },
		},
	},
	line_num = {
		style = "#a6e3a1",
	},
	indent = {
		style = {
			{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui") }
		},
	},
	blank = {
		enable = false,
	},
})

require("hover").setup({
	init = function()
		require("hover.providers.lsp")
		require("hover.providers.gh")
		require("hover.providers.gh_user")
		require("hover.providers.man")
		require("hover.providers.dictionary")
	end,

	preview_opts = {
		border = "rounded",
	},

	preview_window = false,

	title = true,

	mouse_providers = {
		"LSP",
	},

	mouse_delay = 1000,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

local language_servers = require("lspconfig").util.available_servers()

for _, ls in ipairs(language_servers) do
	require("lspconfig")[ls].setup({
		capabilities = capabilities,
	})
end

require("ufo").setup({
	fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" 󰁂 %d "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0

		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)

			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end

			curWidth = curWidth + chunkWidth
		end

		table.insert(newVirtText, { suffix, "MoreMsg" })

		return newVirtText
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LspAttached",
	once = true,
	callback = vim.lsp.codelens.refresh,
})

vim.ui.select = require('dropbar.utils.menu').select
