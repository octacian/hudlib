-- hudlib/text.lua

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
    set_scale = function(x, y)
      hudlib.change(name, hud_name, "scale", {x = x, y = y})
    end,
    set_text = function(str)
      hudlib.change(name, hud_name, "text", str)
    end,
    set_alignment = function(x, y)
      hudlib.change(name, hud_name, "alignment", {x = x or 0, y = y or 0})
    end,
    set_offset = function(x, y)
      hudlib.change(name, hud_name, "offset", {x = x, y = y})
    end,
    set_colour = function(colour)
      hudlib.change(name, hud_name, "number", colour)
    end,
  }

  hud.set_color = hud.set_colour

  return hud
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
