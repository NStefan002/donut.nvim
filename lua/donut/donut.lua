---@class Donut
---@field win_size integer
---@field theta_spacing number
---@field phi_spacing number
---@field illumination table
---@field R1 number
---@field R2 number
---@field K2 number
---@field K1 number
---@field ns_id integer
---@field bufnr integer
---@field timer uv_timer_t
local Donut = {}
Donut.__index = Donut

---@param bufnr integer
---@param size integer
function Donut.new(bufnr, size)
    local self = setmetatable({}, Donut)
    self.ns_id = vim.api.nvim_create_namespace("donut")
    self.bufnr = bufnr
    self.timer = nil

    self.win_size = size
    self.theta_spacing = 0.07
    self.phi_spacing = 0.02
    self.illumination = {
        ".",
        ",",
        "-",
        "~",
        ":",
        ";",
        "=",
        "!",
        "*",
        "#",
        "$",
        "@",
    }
    self.R1 = 1
    self.R2 = 2
    self.K2 = 5
    self.K1 = self.win_size * self.K2 * 3 / (8 * (self.R1 + self.R2))
    return self
end

---@param A number
---@param B number
---@return table
function Donut:render_frame(A, B)
    local cos_A, sin_A = math.cos(A), math.sin(A)
    local cos_B, sin_B = math.cos(B), math.sin(B)

    local output = {}
    for _ = 1, self.win_size do
        local tmp = {}
        for _ = 1, self.win_size do
            table.insert(tmp, " ")
        end
        table.insert(output, tmp)
    end

    local zbuffer = {}
    for _ = 1, self.win_size do
        local tmp = {}
        for _ = 1, self.win_size do
            table.insert(tmp, 0)
        end
        table.insert(zbuffer, tmp)
    end

    local theta = 0.0
    while theta < 2 * math.pi do
        local cos_theta, sin_theta = math.cos(theta), math.sin(theta)

        local phi = 0.0
        while phi < 2 * math.pi do
            local cos_phi, sin_phi = math.cos(phi), math.sin(phi)

            local circle_x = self.R2 + self.R1 * cos_theta
            local circle_y = self.R1 * sin_theta

            local x = circle_x * (cos_B * cos_phi + sin_A * sin_B * sin_phi)
                - circle_y * cos_A * sin_B
            local y = circle_x * (sin_B * cos_phi - sin_A * cos_B * sin_phi)
                + circle_y * cos_A * cos_B
            local z = self.K2 + cos_A * circle_x * sin_phi + circle_y * sin_A
            local ooz = 1 / z

            local xp = math.floor(self.win_size / 2 + self.K1 * ooz * x) + 1
            local yp = math.floor(self.win_size / 2 - self.K1 * ooz * y) + 1

            local L1 = cos_phi * cos_theta * sin_B
                - cos_A * cos_theta * sin_phi
                - sin_A * sin_theta
                + cos_B * (cos_A * sin_theta - cos_theta * sin_A * sin_phi)

            if L1 > 0 then
                if zbuffer[xp] == nil or zbuffer[xp][yp] == nil then
                    print(xp, yp)
                end
                if ooz > zbuffer[xp][yp] then
                    zbuffer[xp][yp] = ooz
                    local luminance_index = math.floor(L1 * 8) + 1
                    output[xp][yp] = self.illumination[luminance_index]
                end
            end

            phi = phi + self.phi_spacing
        end
        theta = theta + self.theta_spacing
    end

    return output
end

function Donut:display_frame(frame)
    local output = {}
    for i = 1, #frame do
        output[i] = " "
        for j = 1, #frame[i] do
            output[i] = string.format("%s%s ", output[i], frame[i][j])
        end
    end
    vim.api.nvim_buf_set_lines(self.bufnr, 0, #output, false, output)
end

function Donut:run()
    local A = 1.0
    local B = 1.0
    if not vim.g.donut_config.sync_donuts then
        A = math.random() * 10
        B = math.random() * 10
    end
    self.timer = (vim.uv or vim.loop).new_timer()
    self.timer:start(
        0,
        50,
        vim.schedule_wrap(function()
            A = A + self.theta_spacing
            B = B + self.phi_spacing
            self:display_frame(self:render_frame(A, B))
        end)
    )
end

function Donut:stop()
    if self.timer then
        self.timer:stop()
        self.timer:close()
        self.timer = nil
    end
    if self.bufnr ~= nil and vim.api.nvim_buf_is_valid(self.bufnr) then
        vim.schedule(function()
            vim.api.nvim_buf_delete(self.bufnr, { force = true })
        end)
    end
end

return Donut
