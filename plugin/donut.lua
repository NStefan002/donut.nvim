if vim.g.donut_loaded then
    return
end

vim.g.donut_loaded = true
require("donut").setup()
