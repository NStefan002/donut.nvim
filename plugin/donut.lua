if vim.g.donut_loaded then
    return
end

vim.g.donut_loaded = true

require("donut").setup()
local spawn = require("donut.donut_spawn").new()
spawn:start_timer()

vim.api.nvim_create_user_command("Donut", function(event)
    if #event.fargs > 0 then
        error("Donut: command does not accept arguments")
    end
    spawn:kill_donuts()
    spawn:spawn_donuts()
end, {
    nargs = 0,
    desc = "Toggle Screenkey",
})
