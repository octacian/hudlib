# API
HUD Plus introduces several API functions which can be used either in your own mod or when developing an official module. These functions make it easier and quicker to manage HUDs, using names rather than relying on IDs. This also allows for more advanced features like showing and hiding an HUD without actually fully destroying it.

#### `after`
__Usage:__ `hudplus.after(<name (string)>, <time (integer)>, <func (function)>)`

This is a nearly drop-in replacement for `minetest.after`, except it can be considered to be slightly more advanced. It uses global steps instead, which are also considered more reliable. The most important change, is that things queued with `after` are placed in a queue table under the name specified. This means that if `after` is called specifying the same name, the time will be updated and the counter reset preventing HUDs and other things from disappearing too quickly in the case of `minetest.after` where calls would get stacked up.

#### `after_remove`
__Usage:__ `hudplus.after_remove(<name (string)>)`

Remove an after call from the queue so that it will not be called when its time is up. After calls using HUD Plus' after function are queued by name. See `after` for more information.

#### `hud_get`
__Usage:__ `hudplus.hud_get(<player (userdata or string)>, <hud name (string)>, <value to get (string, optional)>`

Allows retrieving information about an HUD (including the original definition). The third parameter allows you to specify which piece of information you want to get (e.g. `def`). If the third parameter is `nil` or invalid, the entire table containing all the information about the HUD will be returned.

#### `hud_set`
__Usage:__ `hudplus.hud_set(<player (userdata or string)>, <hud name (string)>, <key to set (string)>, <value>)`

Sets a piece of information for an HUD in the HUDs table where HUD Plus keeps track of registered HUDs. __Note:__ the final `value` parameter can be of any type (e.g. string, table, or boolean).

#### `hud_add`
__Usage:__ `hudplus.hud_add(<player (userdata or string)>, <hud name (string)>, <definition (table)>)`

Adds an HUD to the player. The HUD name should be a unique string (e.g. `game_time`), but typically not an ID as is used by `player:hud_add`. The definition accepts the same parameters as `player:hud_add`, however, `hud_elem_type` can be shortened to `type` and `position` can be shortened to `pos`. An HUD can be hidden by default by setting the `show` attribute to `false` (can be shown with `hud_show`). An HUD can be set to automatically hide itself after a certain number of seconds with `hide_after`. The callback attribute `on_hide` will be called whenever the HUD is hidden, and `on_show` whenever it is shown. `on_step` is called on every globalstep and is provided with the `player` and `dtime`. For further information, see the official developer wiki [documentation](http://dev.minetest.net/HUD). __Note:__ if an HUD with the name specified already exists, the new HUD will not be added.

#### `hud_remove`
__Usage:__ `hudplus.hud_remove(<player (userdata or string)>, <hud name (string)>)`

Removes an HUD from the player. If the HUD specified by the second parameter does not exist, nothing will be removed.

#### `hud_change`
__Usage:__ `hudplus.hud_change(<player (userdata or string)>, <hud name (string)>, <attribute to change (string)>, <new value>)`

Changes an HUD specified by the second parameter previously attached to the player. The third parameter specifies the name of the attribute to change, while the fourth specified the new value. `hud_elem_type` can be shortened to `type` and `position` can be shortened to `pos` (as with `hud_add`).

#### `hud_hide`
__Usage:__ `hudplus.hud_hide(<player (userdata or string)>, <hud name (string)>)`

Non-destructively hides the HUD from the player. `nil` will be returned if the HUD is already hidden or does not exist. Can be shown again with `hud_show`.

#### `hud_show`
__Usage:__ `hudplus.hud_show(<player (userdata or string)>, <hud name (string)>)`

Shows a previously hidden HUD to the player. `nil` will be returned if the HUD is already visible or does not exist. Can be hidden with `hud_hide`.

#### `register`
__Usage:__ `hudplus.register(<hud name (string)>, <definition (table)>)`

Registers an HUD to be shown to all players. Definition and name follow same standards as with `hud_add`. __Note:__ HUDs registered with this API function are only shown to a player when they join the game. If you wish to show an HUD to all players mid-game, set `show_on` to `now`.

#### `unregister`
__Usage:__ `hudplus.unregister(<hud name(string)>)`

Removes and HUD from all players at once. Useful if you need to temporarily disable an HUD for everybody (e.g. changing everyone's gamemode to creative).
