---- APPLICATOR ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function thunk(f)
        if type (f) ~= "function" then return function() return f end end
        return function(...)
                local args = { ... }
                return function() return f (unpack (args)) end
        end
end

---- PATTERN MATCHING ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function execute(act, val)
        if type (act) == "function" then return act (val) end
        return act
end

local function matches(val, pat)
        if type (pat) == "function" then return val == pat (val) end
        if type (pat) == "table" then
                for _, candidate in ipairs (pat) do
                        if matches (val, candidate) then return true end
                end
                return false
        end
        return val == pat
end

local function case(val)
        return function(cases)
                for pat, act in pairs (cases) do
                        if pat ~= "_" and matches (val, pat) then return execute (act, val) end
                end
                if cases._ ~= nil then return execute (cases._, val) end
                return nil
        end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local M      = {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
M.applicator = {
        memo  = memo,
        thunk = thunk,
}
M.matching   = {
        case      = case,
        predicate = {
                _nilq = function(_) return _ ~= nil and _ end,
                nilq  = function(_) return _ == nil and _ end,
                ---- STRING CASE -----------------------------------------------------------------------------------------------------------------------------------------------------------
                lower = function(_) return _:lower () end,
                upper = function(_) return _:upper () end,
                ---- TYPES -----------------------------------------------------------------------------------------------------------------------------------------------------------------
                tblq  = function(x) return type (x) == "table" and x end,
                numq  = function(x) return type (x) == "number" and x end,
                strq  = function(x) return type (x) == "string" and x end,
                booq  = function(x) return type (x) == "boolean" and x end,
                funq  = function(x) return type (x) == "function" and x end,
                typq  = function(t) return function(x) return type (x) == t and x end end,
                ---- COMPARE ---------------------------------------------------------------------------------------------------------------------------------------------------------------
                eq    = function(x) return function(_) return _ == x and _ end end,
                gt    = function(x) return function(_) return _ > x and _ end end,
                lt    = function(x) return function(_) return _ < x and _ end end,
                bt    = function(x) return function(_) return #_ > x and #_ end end,
                neq   = function(x) return function(_) return _ ~= x and _ end end,
                gtq   = function(x) return function(_) return _ >= x and _ end end,
                ltq   = function(x) return function(_) return _ <= x and _ end end,
                btq   = function(x) return function(_) return #_ >= x and #_ end end,
        },
}
setmetatable (M, {
        __call = function(self)
                for _, group in pairs (self) do
                        if type (group) == "table" then
                                for key, val in pairs (group) do
                                        rawset (_G, key, val)
                                end
                        end
                end
        end,
})
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return M
