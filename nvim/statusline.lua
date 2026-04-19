local M = {}

-- Get current mode
function M.mode()
  local modes = {
    n = "-- NORMAL --",
    i = "-- INSERT --",
    v = "-- VISUAL --",
    V = "-- V-LINE --",
    ["\22"] = "-- V-BLOCK --",
    c = "-- COMMAND --",
    s = "-- SELECT --",
    S = "-- S-LINE --",
    ["\19"] = "-- S-BLOCK --",
    R = "-- REPLACE --",
    r = "-- REPLACE --",
    t = "-- TERMINAL --",
  }
  return modes[vim.fn.mode()] or "-- UNKNOWN --"
end

-- Get git branch
function M.branch()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  local branch = handle:read("*a"):gsub("\n", "")
  handle:close()
  
  if branch ~= "" then
    return "(" .. branch .. ")"
  end
  return ""
end

return M
