-- hudlib/hud.lua

local huds  = {}
local every = {}
local efor  = {}

-- [register] Globalstep
minetest.register_globalstep(function(dtime)
  -- [for] Every player in HUD list
  for player, huds in pairs(huds) do
    local pname = minetest.get_player_by_name(player)

    -- [for] Every HUD attached to player
    for _, hud in pairs(huds) do
      -- on_step Callback
      hudlib.event(pname, "step", hud, dtime)

      -- do_every Callback
      if hud.do_every and hud.do_every.time and hud.do_every.func then
        local over_time = hudlib.parse_time(hud.do_every.stop)
        if over_time then
          if not efor[_] then
        		efor[_] = 1
        	end

          efor[_] = efor[_] + dtime
          if efor[_] >= over_time then
            return
          end
        end

        if not every[_] then
      		every[_] = 1
      	end

        local time = hudlib.parse_time(hud.do_every.time)

        every[_] = every[_] + dtime
        if time and every[_] >= time then
          hud.do_every.func(pname)
        end
      end
    end
  end
end)

-- [function] List all HUD elements attached to a player
function hudlib.list(name)
  assert(name, "hudlib.list: Invalid parameter")
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  return huds[name]
end

-- [function] Remove all HUD elements attached to a player
function hudlib.clear(name)
  assert(name, "hudlib.clear: Invalid parameter")
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  local huds = hudlib.list(name)
  for hud, i in pairs(huds) do
    hudlib.remove(name, hud)
  end
end

-- [function] Get HUD
function hudlib.get(name, hud_name, key)
  assert(name and hud_name, "hudlib.get: Invalid parameters")
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
function hudlib.set(name, hud_name, key, value)
  assert(name and hud_name and key, "hudlib.set: Invalid parameters")
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
function hudlib.add(player, hud_name, def)
  assert(player and hud_name and def, "hudlib.add: Invalid parameters")
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

    local on_add    = def.on_add
    def.on_add      = nil
    local on_remove = def.on_remove
    def.on_remove   = nil
    local on_change = def.on_change
    def.on_change   = nil
    local on_show   = def.on_show
    def.on_show     = nil
    local on_hide   = def.on_hide
    def.on_hide     = nil
    local on_step   = def.on_step
    def.on_step     = nil
    local do_every  = def.do_every
    def.do_every    = nil

    local hud = {
      def       = def,
      on_add    = on_add,
      on_remove = on_remove,
      on_change = on_change,
      on_show   = on_show,
      on_hide   = on_hide,
      on_step   = on_step,
      do_every  = do_every,
    }

    if def.show == false then
      hud.show = false
      huds[name][hud_name] = hud
    else
      local id = player:hud_add(def)
      hud.id   = id
      hud.show = true
      huds[name][hud_name] = hud

      if def.hide_after then
        hudlib.after("hide_"..hud_name, def.hide_after, function()
          hudlib.hide(player, hud_name)

          -- Handle event
          hudlib.event(name, "hide", hud)
        end)
      end
    end

    -- Handle event
    hudlib.event(name, "add", huds[name][hud_name])

    return true
  end
end

-- [function] Remove HUD
function hudlib.remove(player, hud_name)
  assert(player and hud_name, "hudlib.remove: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local name = player:get_player_name()
  local hud  = hudlib.get(name, hud_name)
  if hud then
    player:hud_remove(hud.id)

    -- Handle event
    hudlib.event(name, "remove", hud)

    return true
  end
end

-- [function] Change HUD
function hudlib.change(player, hud_name, key, val)
  assert(player and hud_name and key, "hudlib.change: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  if key == "type" then key = "hud_elem_type" end
  if key == "pos"  then key = "position" end

  local name = player:get_player_name()
  local hud  = hudlib.get(name, hud_name)
  if hud then
    player:hud_change(hud.id, key, val)

    -- Update def in hud list
    hud.def[key] = val
    hudlib.set(player, hud_name, "def", hud.def)

    -- Handle event
    hudlib.event(name, "change", hud, key)

    return true
  end
end

-- [function] Hide HUD
function hudlib.hide(player, hud_name)
  assert(player and hud_name, "hudlib.hide: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local name = player:get_player_name()
  local hud  = hudlib.get(name, hud_name)
  if hud then
    if hud.show == true then
      player:hud_remove(hud.id)
      hudlib.set(player, hud_name, "show", false)

      -- Handle event
      hudlib.event(name, "hide", hud)

      return true
    end
  end
end

-- [function] Show HUD
function hudlib.show(player, hud_name)
  assert(player and hud_name, "hudlib.show: Invalid parameters")
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local name = player:get_player_name()
  local hud  = hudlib.get(name, hud_name)
  if hud then
    if hud.show == false then
      hudlib.set(player, hud_name, "id", player:hud_add(hud.def))
      hudlib.set(player, hud_name, "show", true)

      local def = hud.def
      if def.hide_after then
        hudlib.after("hide_"..hud_name, def.hide_after, function()
          hudlib.hide(player, hud_name)

          -- Handle event
          hudlib.event(name, "hide", hud)
        end)
      end

      -- Handle event
      hudlib.event(name, "show", hud)

      return true
    end
  end
end

-- [function] Register HUD
function hudlib.register(hud_name, def)
  local when = def.show_on or "join"
  if when == "join" then
    minetest.register_on_joinplayer(function(player)
      hudlib.add(player, hud_name, def)

      local name = player:get_player_name()
      -- Handle event
      hudlib.event(name, "add", huds[name][hud_name])
    end)
  elseif when == "now" then
    for _, player in pairs(minetest.get_connected_players()) do
      if hudlib.add(player, hud_name, def) then
        -- Handle event
        hudlib.event(name, "add", hud)
      end
    end
  end
end

-- [function] Unregister HUD
function hudlib.unregister(hud_name)
  for player, huds in pairs(huds) do
    hudlib.remove(minetest.get_player_by_name(player), hud_name)
  end
end