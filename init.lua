-- hudlib/init.lua

hudlib = {}

hudlib.VERSION = 0.1
hudlib.RELEASE = "alpha"

local modpath = minetest.get_modpath("hudlib")

-- [function] Log
function hudlib.log(content, log_type)
  if not content then return false end
  if log_type == nil then log_type = "action" end
  minetest.log(log_type, "[HUD Library] "..content)
end

---------------------
---- CHATCOMMAND ----
---------------------

-- [register cmd] /hudlib
minetest.register_chatcommand("hudlib", {
  description = "Check HUD Library version",
  func = function(name)
    return true, "HUD Library: Version "..tostring(hudlib.VERSION).." ("..hudlib.RELEASE..")"
  end,
})

------------------------
-- LOAD API RESOURCES --
------------------------

-- Load Main API
dofile(modpath.."/api.lua")
-- Load HUD API
dofile(modpath.."/hud.lua")

-- Load Image API
dofile(modpath.."/image.lua")
-- Load Text API
dofile(modpath.."/text.lua")
-- Load Inventory API
dofile(modpath.."/inventory.lua")
