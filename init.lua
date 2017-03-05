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

-------------------
----- MODULES -----
-------------------

local loaded_modules = {}

local settings = Settings(modpath.."/modules.conf"):to_table()

-- [function] Get module path
function hudplus.get_module_path(name)
  local module_path = modpath.."/modules/"..name

  if io.open(module_path.."/init.lua") then
    return module_path
  end
end

-- [function] Load module (overrides modules.conf)
function hudplus.load_module(name)
  if loaded_modules[name] ~= false then
    local module_init = hudplus.get_module_path(name).."/init.lua"

    if module_init then
      dofile(module_init)
      loaded_modules[name] = true
      return true
    else
      hudplus.log("Invalid module \""..name.."\". The module either does not exist "..
        "or is missing an init.lua file.", "error")
    end
  else
    return true
  end
end

-- [function] Require module (does not override modules.conf)
function hudplus.require_module(name)
  if settings[name] and settings[name] ~= false then
    return hudplus.load_module(name)
  end
end

for name,enabled in pairs(settings) do
  if enabled ~= false then
    hudplus.load_module(name)
  end
end
