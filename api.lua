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

-- [function] Calculate child
function hudlib.calc_child(name, def)
  local parent = hudlib.get(name, def.parent)

  if not def.constrain then
    def.constrain = { location = true, visibility = true, size = true, view = true }
  end

  -- Set originals
  def.originals = {
    position  = def.position,
    offset    = def.offset,
  }

  if def.constrain.location then
    -- Position constraint
    if def.position then
      def.position = { x = parent.def.position.x + def.position.x, y = parent.def.position.y + def.position.y }
    else
      def.position = parent.def.position
    end

    -- Offset constraint
    if def.offset then
      def.offset = { x = parent.def.offset.x + def.offset.x, y = parent.def.offset.y + def.offset.y }
    else
      def.offset = parent.def.offset
    end
  end

  if def.constrain.size then
    def.scale = parent.def.scale or def.scale
    def.size  = parent.def.size or def.size
  end

  if def.constrain.view then
    def.direction = parent.def.direction or def.direction -- Direction constraint
    def.alignment = parent.def.alignment or def.alignment -- Alignment constraint
  end

  -- Visibility constraint
  if def.constrain.visibility then
    def.show = parent.show or def.show or true
  end

  -- Return updated definition
  return def
end

-- [function] Update child
function hudlib.update_child(name, def)
  local parent = hudlib.get(name, def.parent)

  if not def.constrain then
    def.constrain = { location = true, visibility = true, size = true, view = true }
  end

  if def.constrain.location then
    -- Position constraint
    if def.originals.position then
      def.position = { x = parent.def.position.x + def.originals.position.x, y = parent.def.position.y + def.originals.position.y }
    else
      def.position = parent.def.position
    end

    -- Offset constraint
    if def.originals.offset then
      def.offset = { x = parent.def.offset.x + def.originals.offset.x, y = parent.def.offset.y + def.originals.offset.y }
    else
      def.offset = parent.def.offset
    end
  end

  if def.constrain.size then
    def.scale = parent.def.scale or def.scale -- Scale constraint
    def.size  = parent.def.size or def.size   -- Size constraint
  end

  if def.constrain.view then
    def.direction = def.originals.direction or parent.def.direction -- Direction constraint
    def.alignment = def.originals.alignment or parent.def.alignment -- Alignment constraint
  end

  return def
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

  -- Update children
  for _, i in pairs(hud.children) do
    local child = hudlib.get(name, i)
    local const = child.constrain

    -- Visibility constraints
    if const.visibility then
      if e == "remove" then
        hudlib.remove(name, i)
      elseif e == "show" then
        hudlib.show(name, i)
      elseif e == "hide" then
        hudlib.hide(name, i)
      end
    end

    -- Change event
    if e == "change" then
      local def    = hudlib.get(name, i, "def")
      local newdef = hudlib.update_child(name, def)

      for k, v in pairs(newdef) do
        hudlib.change(name, i, k, v)
      end
    end
  end
end
