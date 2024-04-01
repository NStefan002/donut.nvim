-- TODO: add autocommands for window close, cursor move
-- TODO: add highlights

local Donut = require("donut.donut")

---@class DonutSpawn
---@field win_bufs table<integer, integer> buffers to restore after killing donuts
---@field bufnrs integer[]
---@field donuts Donut[]
---@field win_wrap_options table<integer, boolean>
---@field ns_id integer
local DonutSpawn = {}
DonutSpawn.__index = DonutSpawn

function DonutSpawn.new()
    local self = setmetatable({}, DonutSpawn)
    self.win_bufs = {}
    self.bufnrs = {}
    self.donuts = {}
    self.win_wrap_options = {}
    self.ns_id = vim.api.nvim_create_namespace("donut")
    return self
end

---@param winnr integer
---@return integer bufnr
local function put_buf_in_win(winnr)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(winnr, bufnr)
    return bufnr
end

function DonutSpawn:spawn_donuts()
    local opened_windows = vim.api.nvim_list_wins()
    for _, winnr in ipairs(opened_windows) do
        -- save buffers to restore after killing donuts
        self.win_bufs[winnr] = vim.api.nvim_win_get_buf(winnr)

        local donut_bufnr = put_buf_in_win(winnr)
        vim.api.nvim_set_option_value("filetype", "donut", { buf = donut_bufnr })
        -- do not mess with the user's settings
        self.win_wrap_options[winnr] = vim.wo[winnr].wrap
        vim.wo[winnr].wrap = false
        table.insert(self.bufnrs, donut_bufnr)

        -- calculate donut size
        local win_width = vim.api.nvim_win_get_width(winnr)
        local win_height = vim.api.nvim_win_get_height(winnr)
        local size = math.min(win_height, math.floor(win_width / 2))
        local donut = Donut.new(donut_bufnr, size)
        table.insert(self.donuts, donut)

        donut:run()
    end
end

function DonutSpawn:kill_donuts()
    for win, buf in pairs(self.win_bufs) do
        vim.schedule(function()
            vim.api.nvim_win_set_buf(win, buf)
        end)
    end

    for _, donut in ipairs(self.donuts) do
        donut:stop()
    end
    self.bufnrs = {}

    for winnr, wrap in pairs(self.win_wrap_options) do
        vim.wo[winnr].wrap = wrap
    end
end

return DonutSpawn
