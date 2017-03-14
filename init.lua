-- hudplus/init.lua

hudplus = {}

hudplus.VERSION = 0.1
hudplus.RELEASE = "alpha"

local modpath = minetest.get_modpath("hudplus")

-- [function] Log
function hudplus.log(content, log_type)
  if not content then return false end
  if log_type == nil then log_type = "action" end
  minetest.log(log_type, "[HUD Plus] "..content)
end

---------------------
---- CHATCOMMAND ----
---------------------

-- [register cmd] /hudplus
minetest.register_chatcommand("hudplus", {
  description = "Manage HUD Plus",
  func = function(name)
    return true, "HUD Plus: Version "..tostring(hudplus.VERSION).." ("..hudplus.RELEASE..")"
  end,
})

--------------------
-- LOAD RESOURCES --
--------------------

-- Load API
dofile(modpath.."/api.lua")
