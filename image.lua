-- hudlib/image.lua

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
  set_image = function(self, image)
    hudlib.change(self.player_name, self.name, "text", image)
  end,
  set_alignment = function(self, x, y)
    hudlib.change(self.player_name, self.name, "alignment", {x = x or 0, y = y or 0})
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

-- [function] List images
function hudlib.list_images(name)
  local huds   = hudlib.list(name)
  local images = {}

  for _, hud in pairs(huds) do
    if hud.def.hud_elem_type == "image" then
      images[#images + 1] = _
    end
  end

  return images
end

-- [function] Get image
function hudlib.get_image(name, hud_name)
  return gen(name, hud_name)
end

-- [function] Add image
function hudlib.add_image(name, hud_name, def)
  def.type = "image"
  def.text = def.image

  if hudlib.add(name, hud_name, def) then
    return gen(name, hud_name)
  end
end
