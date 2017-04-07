# API
HUD Library introduces several API functions which can be used either in your own mod or when developing an official module. These functions make it easier and quicker to manage HUDs, using names rather than relying on IDs. This also allows for more advanced features like showing and hiding an HUD without actually fully destroying it. This is the main HUD, which though it can be used as is, it is recommended that you use the sub-APIs for each element for max productivity.

#### `list`
__Usage:__ `hudlib.list(<player (userdata or string)>)`

Lists all the HUDs attached to a player through an HUDLib API.

#### `clear`
__Usage:__ `hudlib.clear(<player (userdata or string)>)`

Removes all HUDs from the player specified. __Note:__ default HUDs or HUDs added by other mods cannot be removed by HUDLib.

#### `get`
__Usage:__ `hudlib.get(<player (userdata or string)>, <hud name (string)>, <value to get (string, optional)>`

Allows retrieving information about an HUD (including the original definition). The third parameter allows you to specify which piece of information you want to get (e.g. `def`). If the third parameter is `nil` or invalid, the entire table containing all the information about the HUD will be returned.

#### `set`
__Usage:__ `hudlib.set(<player (userdata or string)>, <hud name (string)>, <key to set (string)>, <value>)`

Sets a piece of information for an HUD in the HUDs table where HUD Library keeps track of registered HUDs. __Note:__ the final `value` parameter can be of any type (e.g. string, table, or boolean).

#### `add`
__Usage:__ `hudlib.add(<player (userdata or string)>, <hud name (string)>, <definition (table)>)`

Adds an HUD to the player. The HUD name should be a unique string (e.g. `game_time`), but typically not an ID as is used by `player:add`. The definition accepts the same parameters as `player:add`, however, `elem_type` can be shortened to `type` and `position` can be shortened to `pos`. An HUD can be hidden by default by setting the `show` attribute to `false` (can be shown with `show`). An HUD can be set to automatically hide itself after a certain number of seconds with `hide_after`. HUDs support many callbacks in their definition as show below. For further information about HUDs in general, see the official developer wiki [documentation](http://dev.minetest.net/HUD). __Note:__ if an HUD with the name specified already exists, the new HUD will not be added.

One pattern visible below is the fact that a `self` variable is provided to every callback function. Self contains element-specific methods that can be called in the following manner: `self:remove()`. To see more information on the available methods check the documentation for the specific element your are using.

 __Callbacks:__
 - `on_add(self, name)` - called when the HUD is first added to the player
 - `on_remove(self, name)` - called when the HUD is removed from the player
 - `on_change(self, name, key changed)` - called when the HUD is changed
 - `on_show(self, name)` - called when the HUD is shown to the player
 - `on_hide(self, name)` - called when the HUD is hidden from the player
 - `on_step(self, name, dtime)` - called every globalstep
 - `do_every` - called every time the timer specified runs out (see example below for further explanation)

__Example:__
```lua
hudlib.add("singleplayer", "testing", {
  type = "text",
  pos = {x=0.5, y=0},
  offset = {x=0, y=50},
  number = 0xFFFFFF ,
  text = "Hello World!",

  do_every = { time = "1m 2s 1", stop = 10, func = function(self, name)
    --                 ^         ^ Stops do_every from being executed after 10 seconds
    --                 |         | This shows how plain integers can also be used
    --                 | Is intrepreted as 1 minute and 3 seconds (see `hudlib.parse_time`)
    hudlib.change(name, "testing", "text", "Hello at "..minetest.get_timeofday().."!")
    -- ^ Code to be executed every <time>
  end, }
  on_step = function(player, dtime)
    hudlib.log("Stepped "..player:get_player_name().."! ("..dtime..")")
    -- ^ Code to be executed after each globalstep
  end,
  on_show = function()
    hudlib.log("Showed!")
    -- ^ Code to be executed when the HUD is shown to the player
  end,
  on_hide = function()
    hudlib.log("Hidden!")
    -- ^ Code to be executed when the HUD is hidden from the player
  end,
})
```

#### `remove`
__Usage:__ `hudlib.remove(<player (userdata or string)>, <hud name (string)>)`

Removes an HUD from the player. If the HUD specified by the second parameter does not exist, nothing will be removed.

#### `change`
__Usage:__ `hudlib.change(<player (userdata or string)>, <hud name (string)>, <attribute to change (string)>, <new value>)`

Changes an HUD specified by the second parameter previously attached to the player. The third parameter specifies the name of the attribute to change, while the fourth specified the new value. `elem_type` can be shortened to `type` and `position` can be shortened to `pos` (as with `add`).

#### `hide`
__Usage:__ `hudlib.hide(<player (userdata or string)>, <hud name (string)>)`

Non-destructively hides the HUD from the player. `nil` will be returned if the HUD is already hidden or does not exist. Can be shown again with `show`.

#### `show`
__Usage:__ `hudlib.show(<player (userdata or string)>, <hud name (string)>)`

Shows a previously hidden HUD to the player. `nil` will be returned if the HUD is already visible or does not exist. Can be hidden with `hide`.

#### `register`
__Usage:__ `hudlib.register(<hud name (string)>, <definition (table)>)`

Registers an HUD to be shown to all players. Definition and name follow same standards as with `add`. __Note:__ HUDs registered with this API function are only shown to a player when they join the game. If you wish to show an HUD to all players mid-game, set `show_on` to `now`.

#### `unregister`
__Usage:__ `hudlib.unregister(<hud name(string)>)`

Removes and HUD from all players at once. Useful if you need to temporarily disable an HUD for everybody (e.g. changing everyone's gamemode to creative).
