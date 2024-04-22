local M = {}

---@param t table Table to check
---@param value any Value to compare or predicate function reference
---@return boolean `true` if `t` contains `value`
M.tbl_contains = function(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

---@param winnr integer
---@return integer bufnr
function M.put_buf_in_win(winnr)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(winnr, bufnr)
    return bufnr
end

---@param bufnr number
---@return boolean
function M.is_ignored(bufnr)
    local ignore_ft = vim.deepcopy(vim.g.donut_config.ignore.filetype)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    if M.tbl_contains(ignore_ft, filetype) then
        return true
    end

    local ignore_bt = vim.deepcopy(vim.g.donut_config.ignore.buftype)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
    if M.tbl_contains(ignore_bt, buftype) then
        return true
    end

    return false
end

return M
