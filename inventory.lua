-- hudlib/inventory.lua

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
    set_name = function(name)
      hudlib.change(name, hud_name, "text", name)
    end,
    set_number = function(num)
      hudlib.change(name, hud_name, "number", num)
    end,
    set_item = function(item)
      hudlib.change(name, hud_name, "item", item)
    end,
    set_dir = function(dir)
      hudlib.change(name, hud_name, "direction", dir)
    end,
    set_offset = function(x, y)
      hudlib.change(name, hud_name, "offset", {x = x, y = y})
    end,
  }
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
