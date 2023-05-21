require "core"

require("core.utils").load_mappings()

local plugins_path = vim.fn.stdpath("data") .. "/lazy"
local base46_path = plugins_path .. "/base46"
local lazy_path = plugins_path .. "/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazy_path) then
    require("core.bootstrap").bootstrap(base46_path, lazy_path)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazy_path)

require "plugins"
