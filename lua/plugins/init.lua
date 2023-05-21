-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local plugins = {"nvim-lua/plenary.nvim", -- nvchad plugins
{
    "NvChad/extensions",
    branch = "v2.0"
}, {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
        require("base46").load_all_highlights()
    end
}, {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
    config = function()
        require "nvchad_ui"
    end
}, {
    "NvChad/nvterm",
    init = function()
        require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
        require "base46.term"
        require("nvterm").setup(opts)
    end
}, {
    "NvChad/nvim-colorizer.lua",
    init = function()
        require("core.utils").lazy_load "nvim-colorizer.lua"
    end,
    config = function(_, opts)
        require("colorizer").setup(opts)

        -- execute colorizer as soon as possible
        vim.defer_fn(function()
            require("colorizer").attach_to_buffer(0)
        end, 0)
    end
}, {
    "numToStr/Comment.nvim",
    keys = {"gcc", "gbc"},
    init = function()
        require("core.utils").load_mappings "comment"
    end,
    config = function()
        require("Comment").setup()
    end
}, {
    "nvim-tree/nvim-web-devicons",
    opts = function()
        return {
            override = require("nvchad_ui.icons").devicons
        }
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "devicons")
        require("nvim-web-devicons").setup(opts)
    end
}, {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
        require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = function()
        return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
        require("core.utils").load_mappings "blankline"
        dofile(vim.g.base46_cache .. "blankline")
        require("indent_blankline").setup(opts)
    end
}, {
    "nvim-treesitter/nvim-treesitter",
    init = function()
        require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = {"TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo"},
    build = ":TSUpdate",
    opts = function()
        return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "syntax")
        require("nvim-treesitter.configs").setup(opts)
    end
}, -- git stuff
{
    "lewis6991/gitsigns.nvim",
    ft = {"gitcommit", "diff"},
    init = function()
        -- load gitsigns only when a git file is opened
        vim.api.nvim_create_autocmd({"BufRead"}, {
            group = vim.api.nvim_create_augroup("GitSignsLazyLoad", {
                clear = true
            }),
            callback = function()
                vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
                if vim.v.shell_error == 0 then
                    vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                    vim.schedule(function()
                        require("lazy").load {
                            plugins = {"gitsigns.nvim"}
                        }
                    end)
                end
            end
        })
    end,
    opts = function()
        return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "git")
        require("gitsigns").setup(opts)
    end
}, -- lsp & complete
{
    "neoclide/coc.nvim",
    branch = "release",
    event = "insertEnter",
    config = function()
        require "plugins.configs.coc_nvim"
    end
}, -- file managing , picker etc
{
    "nvim-tree/nvim-tree.lua",
    cmd = {"NvimTreeToggle", "NvimTreeFocus"},
    init = function()
        require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
        return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "nvimtree")
        require("nvim-tree").setup(opts)
        vim.g.nvimtree_side = opts.view.side
    end
}, {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    init = function()
        require("core.utils").load_mappings "telescope"
    end,
    opts = function()
        return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "telescope")
        local telescope = require "telescope"
        telescope.setup(opts)

        -- load extensions
        for _, ext in ipairs(opts.extensions_list) do
            telescope.load_extension(ext)
        end
    end
}, -- Only load whichkey after all the gui
{
    "folke/which-key.nvim",
    keys = {"<leader>", '"', "'", "`", "c", "v"},
    init = function()
        require("core.utils").load_mappings "whichkey"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "whichkey")
        require("which-key").setup(opts)
    end
}}

require("lazy").setup(plugins, require("plugins.configs.lazy_nvim"))
