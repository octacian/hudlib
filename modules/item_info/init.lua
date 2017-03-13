-- item_info/init.lua

local wield = {}
local after = 3 -- HUD element will be hidden after this many seconds

hudplus.register("item_info", {
  show_on = "join",
  type = "text",
  pos = {x=0.5, y=1},
  offset = {x=0, y=-80},
  alignment = {x=0, y=0},
  number = 0xFFFFFF ,
  text = "",
  hide_after = after,

  on_step = function(player, dtime)
    local pname  = player:get_player_name()
    local wstack = player:get_wielded_item()
    local windex = player:get_wield_index()

    local meta = wstack:get_meta()
    local desc = minetest.registered_items[wstack:get_name()].description
    if meta:get_string("description") ~= "" then
      desc = meta:get_string("description")
    end

    local itemstring = " ("..wstack:get_name()..")"
    if wstack:get_name() == "" then itemstring = "" end

    hudplus.hud_change(player, "item_info", "text", desc..itemstring)

    if wield[pname] ~= windex then
			local show = hudplus.hud_get(player, "item_info", "show")
		  if show == false then
		    hudplus.hud_show(player, "item_info")
		  end

		  -- Update timer
		  hudplus.after("hide_item_info", after, function() hudplus.hud_hide(player, "item_info") end)
		end

    wield[pname] = windex
  end,
})
