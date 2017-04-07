-- hudlib/statbar.lua

local hud_health = true
local hud_breath = true

-- [local function] Generate methods
local function gen(name, hud_name)
  local hud = {
    remove = function()
      hudlib.remove(name, hud_name)
    end,
    hide = function()
      hudlib.hide(name, hud_name)
    end,
    show = function()
      hudlib.show(name, hud_name)
    end,
    set_pos = function(x, y)
      hudlib.change(name, hud_name, "position", {x = x, y = y})
    end,
    set_texture = function(texture)
      hudlib.change(name, hud_name, "text", texture)
    end,
    set_dir = function(dir)
      hudlib.change(name, hud_name, "direction", dir)
    end,
    set_offset = function(x, y)
      hudlib.change(name, hud_name, "offset", {x = x, y = y})
    end,
    set_size = function(x, y)
      hudlib.change(name, hud_name, "size", {x = x, y = y})
    end,

    set_min = function(min)
      hudlib.set(name, hud_name, "min", min)

      if hudlib.get(name, hud_name, "def").number < min then
        hudlib.change(name, hud_name, "number", min)
      end
    end,
    set_max = function(max)
      hudlib.set(name, hud_name, "max", max)

      if hudlib.get(name, hud_name, "def").number > max then
        hudlib.change(name, hud_name, "number", max)
      end
    end,
    set_status = function(num)
      local def = hudlib.get(name, hud_name, "def")

      if num < def.min then
        hudlib.change(name, hud_name, "number", def.min)
      elseif num > def.max then
        hudlib.change(name, hud_name, "number", def.max)
      else
        hudlib.change(name, hud_name, "number", num)
      end
    end,

    get_status = function()
      local def = hudlib.get(name, hud_name, "def")
      return def.number or 0
    end
  }

  hud.color = hud.colour

  return hud
end

-- [function] List statbar elements
function hudlib.list_statbars(name)
  local huds  = hudlib.list(name)
  local elems = {}

  for _, hud in pairs(huds) do
    if hud.def.hud_elem_type == "statbar" then
      elems[#elems + 1] = _
    end
  end

  return elems
end

-- [function] Get statbar element
function hudlib.get_statbar(name, hud_name)
  return gen(name, hud_name)
end

-- [function] Add statbar element
function hudlib.add_statbar(name, hud_name, def)
  if type(name) == "userdata" then
    name = name:get_player_name()
  end

  local player = minetest.get_player_by_name(name)

  def.type   = "statbar"
  def.text   = def.texture or def.text
  def.number = def.start or def.max or 20

  if def.number > def.max then
    def.number = def.max
  end

  if hudlib.add(name, hud_name, def) then
    -- Check if replacing builtin statbars
    local hud_flags = player:hud_get_flags()
    if def.replace == "health" then
      hud_flags.healthbar = false
    elseif def.replace == "breath" then
      hud_flags.breathbar = false
    end
    player:hud_set_flags(hud_flags)

    local regen = def.regenerate
    if regen and regen.every then
      regen.allow = regen.allow or true
      regen.step  = regen.step or 1

      hudlib.recur("statbar_"..hud_name, regen.every, function()
        if regen.allow then
          local bar = hudlib.get_statbar(name, hud_name)
          bar.set_status(bar.get_status() + regen.step)

          if regen.func then
            regen.func()
          end
        end
      end)
    end

    local deplete = def.deplete
    if deplete and deplete.every then
      deplete.allow = deplete.allow or true
      deplete.step  = deplete.step or 1

      hudlib.recur("statbar_"..hud_name, deplete.every, function()
        if deplete.allow then
          local bar = hudlib.get_statbar(name, hud_name)
          bar.set_status(bar.get_status() - deplete.step)

          if deplete.func then
            deplete.func()
          end
        end
      end)
    end

    return gen(name, hud_name)
  end
end
