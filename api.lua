-- hudplus/api.lua

local huds = {}

-- [function] Get HUD
function hudplus.hud_get(name, hud_name, key)
  assert(name and hud_name, "hudplus.hud_get: Invalid parameters")
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  if not huds[name] then
    huds[name] = {}
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
      local id = player:hud_add(def)
      huds[name][hud_name] = {
        id   = id,
        def  = def,
        show = true,
      }

      if def.hide_after then
        minetest.after(def.hide_after, function()
          hudplus.hud_hide(player, hud_name)

          if def.on_hide then
            def.on_hide()
          end
        end)
      end

      return id
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
      hud.show = false

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
      hud.id = player:hud_add(hud.def)
      hud.show = true

      local def = hud.def
      if def.hide_after then
        minetest.after(def.hide_after, function()
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
