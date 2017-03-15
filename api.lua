-- hudlib/api.lua

local queue = {}
local times = {}

-- [function] After
function hudlib.after(name, time, func)
  queue[name] = { time = time, func = func, }

  -- Update times table
  if times[name] then
  	times[name] = 1
  end
end

-- [function] Destroy after
function hudlib.after_remove(name)
  if queue[name] then
  	queue[name] = nil
  	return true
  end
end

-- [register] Globalstep
minetest.register_globalstep(function(dtime)
  -- Queue
  for _, i in pairs(queue) do
  	if not times[_] then
  		times[_] = 1
  	end

		times[_] = times[_] + dtime
		if times[_] >= i.time then
			i.func()
			hudlib.after_remove(_)
			times[_] = nil
		end
  end
end)

-- [function] List all HUD elements attached to a player
function hudlib.list(name)
  assert(name, "hudlib.list: Invalid parameter")
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  return hudlib.huds[name]
end

-- [function] Remove all HUD elements attached to a player
function hudlib.clear(name)
  assert(name, "hudlib.clear: Invalid parameter")
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  local huds = hudlib.list(name)
  for hud, i in pairs(huds) do
    hudlib.hud_remove(name, hud)
  end
end
