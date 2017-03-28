-- hudlib/image.lua

-- [local function] Generate methods
local function gen(name, hud_name)
  return {
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
    set_scale = function(x, y)
      hudlib.change(name, hud_name, "scale", {x = x, y = y})
    end,
    set_image = function(image)
      hudlib.change(name, hud_name, "text", image)
    end,
    set_alignment = function(x, y)
      hudlib.change(name, hud_name, "alignment", {x = x or 0, y = y or 0})
    end,
    set_offset = function(x, y)
      hudlib.change(name, hud_name, "offset", {x = x, y = y})
    end,
  }
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
