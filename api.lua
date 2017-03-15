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

-- [function] Parse Time
function hudlib.parse_time(str)
  if not str then return end

  if type(str) == "number" then
    return str
  end

  str = str:split(" ")
  if string and #string <= 3 then
    local time = 0

    for _, t in pairs(str) do
      local last = t:sub(#t, #t)
      t2 = tonumber(t:sub(1, -2))
      if last == "s" then
        time = time + t2
      elseif last == "m" then
        time = time + t2 * 60
      elseif last == "h" then
        time = time + t2 * 60 * 60
      elseif tonumber(last) then
        time = time + tonumber(t)
      end
    end

    return time
  end
end

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
