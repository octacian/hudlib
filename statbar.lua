-- hudlib/statbar.lua

local metatable = {
  remove = function(self)
    hudlib.remove(self.player_name, self.name)
  end,
  hide = function(self)
    hudlib.hide(self.player_name, self.name)
  end,
  show = function(self)
    hudlib.show(self.player_name, self.name)
  end,
  set_pos = function(self, x, y)
    hudlib.change(self.player_name, self.name, "position", {x = x, y = y})
  end,
  set_texture = function(self, texture)
    hudlib.change(self.player_name, self.name, "text", texture)
  end,
  set_dir = function(self, dir)
    hudlib.change(self.player_name, self.name, "direction", dir)
  end,
  set_offset = function(self, x, y)
    hudlib.change(self.player_name, self.name, "offset", {x = x, y = y})
  end,
  set_size = function(self, x, y)
    hudlib.change(self.player_name, self.name, "size", {x = x, y = y})
  end,

  set_min = function(self, min)
    hudlib.set(self.player_name, self.name, "min", min)

    if self.def.number and self.def.number < min then
      hudlib.change(self.player_name, self.name, "number", min)
    end
  end,
  set_max = function(self, max)
    hudlib.set(self.player_name, self.name, "max", max)

    if self.def.number and self.def.number > max then
      hudlib.change(self.player_name, self.name, "number", max)
    end
  end,
  set_status = function(self, num)
    local def = self.def

    if def.min and num < def.min then
      hudlib.change(self.player_name, self.name, "number", def.min)
    elseif def.max and num > def.max then
      hudlib.change(self.player_name, self.name, "number", def.max)
    else
      hudlib.change(self.player_name, self.name, "number", num)
    end
  end,

  get_status = function(self)
    return self.def.number or 0
  end,
}
metatable.color = metatable.colour

-- [local function] Generate methods
local function gen(name, hud_name)
  return setmetatable({
    player_name = name, name = hud_name, def = hudlib.get(name, hud_name, "def")
  }, {__index = metatable})
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

    if def.background and def.max then
      hudlib.add(name, hud_name.."_background", {
        type = "statbar",
        parent = hud_name,
        number = def.max,
        text = def.background,
      })
    end

    return gen(name, hud_name)
  end
end
