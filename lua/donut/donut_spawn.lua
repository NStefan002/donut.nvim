---@class DonutSpawn
---@field bufnrs integer[]
---@field winnrs integer[]
---@field donuts Donut[]
---@field time_since_last_keypress integer
---@field active boolean
---@field ns_id integer
---@field timer uv_timer_t
---@field _min_donut_width integer
---@field _min_donut_height integer
local DonutSpawn = {}
DonutSpawn.__index = DonutSpawn

function DonutSpawn.new()
    local self = setmetatable({
        bufnrs = {},
        winnrs = {},
        donuts = {},
        time_since_last_keypress = 0,
        active = false,
        ns_id = vim.api.nvim_create_namespace("donut"),
        timer = nil,
        _min_donut_width = 15,
        _min_donut_height = 9,
    }, DonutSpawn)
    return self
end

function DonutSpawn:spawn_donuts()
    self.active = true
    local opened_windows = vim.tbl_filter(function(win_id)
        local width = vim.api.nvim_win_get_width(win_id)
        local height = vim.api.nvim_win_get_height(win_id)
        return width > self._min_donut_width and height > self._min_donut_height
    end, vim.api.nvim_list_wins())
    for _, winnr in ipairs(opened_windows) do
        local position = vim.api.nvim_win_get_position(winnr)
        local width = vim.api.nvim_win_get_width(winnr)
        local height = vim.api.nvim_win_get_height(winnr)
        local donut_bufnr = vim.api.nvim_create_buf(false, true)
        local donut_winnr = vim.api.nvim_open_win(donut_bufnr, false, {
            relative = "editor",
            row = position[1],
            col = position[2],
            width = width,
            height = height,
            style = "minimal",
        })
        vim.api.nvim_set_option_value("filetype", "donut", { buf = donut_bufnr })
        vim.wo[donut_winnr].wrap = false

        local donut = require("donut.donut").new(donut_bufnr, donut_winnr)
        donut:run()

        table.insert(self.bufnrs, donut_bufnr)
        table.insert(self.winnrs, donut_winnr)
        table.insert(self.donuts, donut)
    end
end

function DonutSpawn:kill_donuts()
    for _, donut in ipairs(self.donuts) do
        donut:stop()
    end
    self.donuts = {}
    self.bufnrs = {}
    self.winnrs = {}
    self.active = false
end

function DonutSpawn:start_timer()
    vim.on_key(function()
        self.time_since_last_keypress = 0
        if self.active then
            self:kill_donuts()
        end
    end, self.ns_id)

    self.timer = (vim.uv or vim.loop).new_timer()
    self.timer:start(
        0,
        1000,
        vim.schedule_wrap(function()
            if vim.g.donut_config.timeout == 0 then
                return
            end
            self.time_since_last_keypress = self.time_since_last_keypress + 1
            if self.time_since_last_keypress > vim.g.donut_config.timeout and not self.active then
                self:spawn_donuts()
            end
        end)
    )
end

function DonutSpawn:create_autocmds()
    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup
    local grp = augroup("SpeedTyperUI", {})

    autocmd({ "VimResized" }, {
        group = grp,
        callback = function()
            if not self.active then
                return
            end
            vim.schedule(function()
                self:kill_donuts()
            end)
            vim.schedule(function()
                self:spawn_donuts()
            end)
        end,
    })
end

return DonutSpawn.new()
