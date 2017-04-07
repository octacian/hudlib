-- hudlib/waypoint.lua

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
  set_name = function(self, str)
    hudlib.change(self.player_name, self.name, "name", str)
  end,
  set_suffix = function(self, str)
    hudlib.change(self.player_name, self.name, "text", str)
  end,
  set_colour = function(self, colour)
    hudlib.change(self.player_name, self.name, "number", colour)
  end,
  set_pos = function(self, pos)
    hudlib.change(self.player_name, self.name, "world_pos", pos)
  end,
  set_max = function(self, max)
    hudlib.set(self.player_name, self.name, "max", max)
  end,
}
metatable.color = metatable.colour

-- [local function] Generate methods
local function gen(name, hud_name)
  return setmetatable({
    player_name = name, name = hud_name, def = hudlib.get(name, hud_name, "def")
  }, {__index = metatable})
end

-- [function] List waypoint elements
function hudlib.list_waypoints(name)
  local huds  = hudlib.list(name)
  local elems = {}

  for _, hud in pairs(huds) do
    if hud.def.hud_elem_type == "waypoint" then
      elems[#elems + 1] = _
    end
  end

  return elems
end

-- [function] Get waypoint element
function hudlib.get_waypoint(name, hud_name)
  return gen(name, hud_name)
end

-- [function] Add waypoint element
function hudlib.add_waypoint(name, hud_name, def)
  def.type      = "waypoint"
  def.text      = def.suffix or def.text
  def.number    = def.colour or def.color or def.number
  def.world_pos = def.pos or def.world_pos

  if def.max and def.max > 0 then
    local step   = def.on_step
    local player = minetest.get_player_by_name(name)

    def.on_step = function(name, dtime)
      if step then step(name, dtime) end
      local waypoint = hudlib.get_waypoint(name, hud_name)

      if vector.distance(def.world_pos, player:getpos()) >= def.max then
        waypoint.hide()
      else
        if hudlib.get(name, hud_name, "show") == false then
          waypoint.show()
        end
      end
    end
  end

  if hudlib.add(name, hud_name, def) then
    return gen(name, hud_name)
  end
end
