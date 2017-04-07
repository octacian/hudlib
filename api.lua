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

local recur       = {}
local recur_times = {}

-- [function] Register recurring
function hudlib.recur(name, every, func, endt)
  recur[name] = { every = every, stop_after = endt, func = func, }

  -- Update recur times table
  if recur_times[name] then
    recur_times[name] = { time = 0, num = 0, }
  end
end

-- [function] Stop recurring
function hudlib.recur_stop(name)
  if recur[name] then
    recur[name] = nil
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

  -- Recurring
  for _, i in pairs(recur) do
    if not recur_times[_] then
      recur_times[_] = { time = 1, num = 0, }
    end

    recur_times[_].time = recur_times[_].time + dtime
    if recur_times[_].time >= i.every then
      i.func()
      recur_times[_].time = 0
      recur_times[_].num  = recur_times[_].num + 1

      if i.stop_after and recur_times[_].num > i.stop_after then
        hudlib.recur_stop(_)
      end
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

-- [function] Handle Event
function hudlib.event(name, e, hud, ...)
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  local hself = hudlib["get_"..hud.def.hud_elem_type](name, hud.name)

  if hud then
    if e == "add" then
      if hud.on_add then
        hud.on_add(hself, name, ...)
      end
    elseif e == "remove" then
      if hud.on_remove then
        hud.on_remove(hself, name, ...)
      end
    elseif e == "change" then
      if hud.on_change then
        hud.on_change(hself, name, ...)
      end
    elseif e == "show" then
      if hud.on_show then
        hud.on_show(hself, name, ...)
      end
    elseif e == "hide" then
      if hud.on_hide then
        hud.on_hide(hself, name, ...)
      end
    elseif e == "step" then
      if hud.on_step then
        hud.on_step(hself, name, ...)
      end
    elseif e == "every" then
      if hud.do_every.func then
        hud.do_every.func(hself, name, ...)
      end
    end
  end
end
