---@class DonutConfig
---@field timeout integer
---@field sync_donuts boolean

---@type DonutConfig
vim.g.donut_config = { timeout = 300, sync_donuts = false }

-- expose only necessary api
local M = {}

---@param opts? DonutConfig
function M.setup(opts)
    vim.g.donut_config = vim.tbl_deep_extend("force", vim.g.donut_config, opts or {})
end

return M
