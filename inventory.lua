-- hudlib/inventory.lua

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
  set_name = function(self, name)
    hudlib.change(self.player_name, self.name, "text", name)
  end,
  set_number = function(self, num)
    hudlib.change(self.player_name, self.name, "number", num)
  end,
  set_item = function(self, item)
    hudlib.change(self.player_name, self.name, "item", item)
  end,
  set_dir = function(self, dir)
    hudlib.change(self.player_name, self.name, "direction", dir)
  end,
  set_offset = function(self, x, y)
    hudlib.change(self.player_name, self.name, "offset", {x = x, y = y})
  end,
}

-- [local function] Generate methods
local function gen(name, hud_name)
  return setmetatable({
    player_name = name, name = hud_name, def = hudlib.get(name, hud_name, "def")
  }, {__index = metatable})
end

-- [function] List inventory elements
function hudlib.list_inv(name)
  local huds  = hudlib.list(name)
  local elems = {}

  for _, hud in pairs(huds) do
    if hud.def.hud_elem_type == "inventory" then
      elems[#elems + 1] = _
    end
  end

  return elems
end

-- [function] Get inventory element
function hudlib.get_inv(name, hud_name)
  return gen(name, hud_name)
end

-- [function] Add inventory element
function hudlib.add_inv(name, hud_name, def)
  def.type = "inventory"
  def.text = def.name or def.text

  if hudlib.add(name, hud_name, def) then
    return gen(name, hud_name)
  end
end
