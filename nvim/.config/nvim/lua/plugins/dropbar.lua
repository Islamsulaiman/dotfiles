-- This plugin to manage the folder structure breadcrumb and the file breadcrumb
return {
    {
        "Bekaboo/dropbar.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- For file/folder icons
        },
        opts = {
            general = {
                enable = function(buf, win)
                    return vim.fn.win_gettype(win) == ""
                        and vim.bo[buf].buftype == ""
                        and vim.api.nvim_buf_get_name(buf) ~= ""
                        and vim.bo[buf].filetype ~= "toggleterm"
                end,
            },
            bar = {
                sources = function()
                    local sources = require("dropbar.sources")
                    return {
                        sources.path, -- Folder structure breadcrumbs
                        sources.lsp, -- Code-level breadcrumbs via LSP
                    }
                end,
                separator = " ➤ ", -- Stylized separator
            },
            icons = {
                kinds = {
                    File = "📄 ",
                    Folder = "📁 ",
                    Module = "📦 ",
                    Namespace = "🌍 ",
                    Package = "📦 ",
                    Class = "🏛 ",
                    Method = "⚙️ ",
                    Property = "🏷️ ",
                    Field = "🌾 ",
                    Constructor = "🛠️ ",
                    Enum = "🔢 ",
                    Interface = "🔗 ",
                    Function = "📋 ",
                    Variable = "📍 ",
                    Constant = "🔒 ",
                    String = "🧵 ",
                    Number = "🔟 ",
                    Boolean = "🔄 ",
                    Array = "📚 ",
                    Object = "📦 ",
                    Key = "🔑 ",
                    Null = "∅ ",
                    EnumMember = "🔣 ",
                    Struct = "🗳️ ",
                    Event = "⚡ ",
                    Operator = "🔧 ",
                    TypeParameter = "📏 ",
                },
                ui = {
                    bar = {
                        separator = " ➤ ",
                        extends = "…",
                    },
                },
            },
            menu = {
                keymaps = {
                    ["q"] = "<C-w>c", -- Close menu with 'q'
                },
                -- Set keymaps dynamically when menu opens
                on_menu_open = function(menu)
                    vim.notify("Menu opened, setting keymaps")
                    vim.api.nvim_buf_set_keymap(
                        menu.buf,
                        "n",
                        "<CR>",
                        [[<Cmd>lua local menu = require("dropbar.api").get_current_dropbar_menu(); if menu then require("dropbar.api").goto_context(vim.api.nvim_win_get_cursor(0)[1]) end<CR>]],
                        { noremap = true, silent = true, desc = "Jump to selected item" }
                    )
                end,
            },
        },
        config = function(_, opts)
            require("dropbar").setup(opts)
            -- Add keymap for interactive pick mode
            vim.keymap.set("n", "<leader>;", require("dropbar.api").pick, { desc = "Pick symbols in winbar" })
        end,
    },
}
