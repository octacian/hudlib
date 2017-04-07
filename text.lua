-- hudlib/text.lua

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
  set_scale = function(self, x, y)
    hudlib.change(self.player_name, self.name, "scale", {x = x, y = y})
  end,
  set_text = function(self, str)
    hudlib.change(self.player_name, self.name, "text", str)
  end,
  set_alignment = function(self, x, y)
    hudlib.change(self.player_name, self.name, "alignment", {x = x or 0, y = y or 0})
  end,
  set_offset = function(self, x, y)
    hudlib.change(self.player_name, self.name, "offset", {x = x, y = y})
  end,
  set_colour = function(self, colour)
    hudlib.change(self.player_name, self.name, "number", colour)
  end,
}
metatable.set_color = metatable.set_colour

-- [local function] Generate methods
local function gen(name, hud_name)
  return setmetatable({
    player_name = name, name = hud_name, def = hudlib.get(name, hud_name, "def")
  }, {__index = metatable})
end

-- [function] List text elements
function hudlib.list_text(name)
  local huds  = hudlib.list(name)
  local elems = {}

  for _, hud in pairs(huds) do
    if hud.def.hud_elem_type == "text" then
      elems[#elems + 1] = _
    end
  end

  return elems
end

-- [function] Get text element
function hudlib.get_text(name, hud_name)
  return gen(name, hud_name)
end

-- [function] Add text element
function hudlib.add_text(name, hud_name, def)
  def.type   = "text"
  def.number = def.colour or def.color or def.number

  if hudlib.add(name, hud_name, def) then
    return gen(name, hud_name)
  end
end
