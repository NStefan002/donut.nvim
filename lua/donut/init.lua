local Donut = require("donut.donut")

---@class DonutConfig
---@field timeout integer

---@class DonutSpawn
---@field opts DonutConfig
---@field win_bufs table<integer, integer> buffers to restore after killing donuts
---@field bufnrs integer[]
---@field donuts Donut[]
---@field win_wrap_options table<integer, boolean>
---@field time_since_last_keypress integer
---@field active boolean
---@field ns_id integer
---@field timer uv_timer_t
local DonutSpawn = {}
DonutSpawn.__index = DonutSpawn

function DonutSpawn.new()
    local self = setmetatable({
        opts = { timeout = 60 },
        win_bufs = {},
        bufnrs = {},
        donuts = {},
        win_wrap_options = {},
        time_since_last_keypress = 0,
        active = false,
        ns_id = vim.api.nvim_create_namespace("donut"),
        timer = nil,
    }, DonutSpawn)
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
    self.win_bufs = {}

    for _, donut in ipairs(self.donuts) do
        donut:stop()
    end
    self.bufnrs = {}

    for winnr, wrap in pairs(self.win_wrap_options) do
        vim.wo[winnr].wrap = wrap
    end
    self.win_wrap_options = {}
end

function DonutSpawn:start_timer()
    vim.on_key(function(_)
        self.time_since_last_keypress = 0
        if self.active then
            self.active = false
            self:kill_donuts()
        end
    end, self.ns_id)

    self.timer = (vim.uv or vim.loop).new_timer()
    self.timer:start(
        0,
        1000,
        vim.schedule_wrap(function()
            self.time_since_last_keypress = self.time_since_last_keypress + 1
            if self.time_since_last_keypress > self.opts.timeout and not self.active then
                self.active = true
                self:spawn_donuts()
            end
        end)
    )
end

-- expose only necessary api
local M = {}

---@param opts? DonutConfig
function M.setup(opts)
    local spawn = DonutSpawn.new()
    spawn.opts = vim.tbl_deep_extend("force", spawn.opts, opts or {})
    spawn:start_timer()
end

return M
