-- hudplus/api.lua

local huds  = {}
local queue = {}
local times = {}

-- [function] After
function hudplus.after(name, time, func)
  queue[name] = { time = time, func = func, }

  -- Update times table
  if times[name] then
  	times[name] = 1
  end
end

-- [function] Destroy after
function hudplus.after_remove(name)
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
			hudplus.after_remove(_)
			times[_] = nil
		end
  end

  -- on_step Callback
  for player, huds in pairs(huds) do
    for _, hud in pairs(huds) do
      if hud.on_step then
        hud.on_step(minetest.get_player_by_name(player), dtime)
      end
    end
  end
end)

-- [function] Get HUD
function hudplus.hud_get(name, hud_name, key)
  assert(name and hud_name, "hudplus.hud_get: Invalid parameters")
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  if not huds[name] then
    return
  end

  local hud = huds[name][hud_name]
  if hud then
    if key then
      return hud[key]
    else
      return hud
    end
  end
end

-- [function] Set HUD Value
function hudplus.hud_set(name, hud_name, key, value)
  assert(name and hud_name and key, "hudplus.hud_set: Invalid parameters")
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  if not huds[name] then
    return
  end

  if huds[name][hud_name] then
    huds[name][hud_name][key] = value
    return true
  end
end

-- [function] Add HUD
function hudplus.hud_add(player, hud_name, def)
  assert(player and hud_name and def, "hudplus.hud_add: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local name = player:get_player_name()
  if not huds[name] then
    huds[name] = {}
  end

  if not huds[name][hud_name] then
    def.hud_elem_type = def.type or def.hud_elem_type
    def.position      = def.pos or def.position

    if def.show == false then
      huds[name][hud_name] = {
        def  = def,
        show = false,
      }
    else
      local on_step = def.on_step
      def.on_step = nil

      local id = player:hud_add(def)
      huds[name][hud_name] = {
        id      = id,
        def     = def,
        show    = true,
        on_step = on_step,
      }

      if def.hide_after then
        hudplus.after("hide_"..hud_name, def.hide_after, function()
          hudplus.hud_hide(player, hud_name)

          if def.on_hide then
            def.on_hide()
          end
        end)
      end

      return true
    end
  end
end

-- [function] Remove HUD
function hudplus.hud_remove(player, hud_name)
  assert(player and hud_name, "hudplus.hud_remove: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local name = player:get_player_name()
  local hud  = hudplus.hud_get(name, hud_name)
  if hud then
    player:hud_remove(hud.id)
    return true
  end
end

-- [function] Change HUD
function hudplus.hud_change(player, hud_name, key, val)
  assert(player and hud_name and key, "hudplus.hud_change: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  if key == "type" then key = "hud_elem_type" end
  if key == "pos"  then key = "position" end

  local name = player:get_player_name()
  local hud  = hudplus.hud_get(name, hud_name)
  if hud then
    player:hud_change(hud.id, key, val)

    -- Update def in hud list
    hud.def[key] = val
    hudplus.hud_set(player, hud_name, "def", hud.def)
    return true
  end
end

-- [function] Hide HUD
function hudplus.hud_hide(player, hud_name)
  assert(player and hud_name, "hudplus.hud_hide: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local name = player:get_player_name()
  local hud  = hudplus.hud_get(name, hud_name)
  if hud then
    if hud.show == true then
      player:hud_remove(hud.id)
      hudplus.hud_set(player, hud_name, "show", false)

      local def = hud.def
      if def.on_hide then
        def.on_hide()
      end

      return true
    end
  end
end

-- [function] Show HUD
function hudplus.hud_show(player, hud_name)
  assert(player and hud_name, "hudplus.hud_hide: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local name = player:get_player_name()
  local hud  = hudplus.hud_get(name, hud_name)
  if hud then
    if hud.show == false then
      hudplus.hud_set(player, hud_name, "id", player:hud_add(hud.def))
      hudplus.hud_set(player, hud_name, "show", true)

      local def = hud.def
      if def.hide_after then
        hudplus.after("hide_"..hud_name, def.hide_after, function()
          hudplus.hud_hide(player, hud_name)

          if def.on_hide then
            def.on_hide()
          end
        end)
      end

      if def.on_show then
        def.on_show()
      end

      return true
    end
  end
end

-- [function] Register HUD
function hudplus.register(hud_name, def)
  local when = def.show_on or "join"
  if when == "join" then
    minetest.register_on_joinplayer(function(player)
      hudplus.hud_add(player, hud_name, def)

      if def.on_add then
        def.on_add(player)
      end
    end)
  elseif when == "now" then
    for _, player in pairs(minetest.get_connected_players()) do
      if hudplus.hud_add(player, hud_name, def) then
        if def.on_add then
          def.on_add(player)
        end
      end
    end
  end
end

-- [function] Unregister HUD
function hudplus.unregister(hud_name)
  for player, huds in pairs(huds) do
    hudplus.hud_remove(minetest.get_player_by_name(player), hud_name)
  end
end
