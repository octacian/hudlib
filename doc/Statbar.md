# Statbars
The API for statbar HUD elements is based off of the main API, however, it makes things even easier when it comes to manipulating the statbar HUDs. The main reason why this sub-API makes things easier, is that it presents a table for each statbar element, suited with several functions to manipulate it without requiring that the identification of the element be provided each time you make a change.

#### `list_statbar`
__Usage:__ `hudlib.list_statbar(<player (userdata or string)>)`

Lists all statbar elements attached to a player.

#### `get_statbar`
__Usage:__ `hudlib.get_statbar(<player (userdata or string)>, <hud name (string)>)`

Returns a table containing all of the helpers which allow manipulation of the text element. Helpers can be called in this method: `hudlib.get_statbar(...):remove()` (see below for all available helpers).

__Helpers:__
- `remove()` - removes the statbar HUD element
- `hide()` - hides the statbar
- `show()` - shows the statbar (if it is hidden)
- `set_pos(name)` - sets position of statbar
- `set_texture(texture)` - set statbar texture
- `set_dir(dir)` - set direction in which statbar should be shown (0 draws from left to right, 1 draws from right to left, 2 draws from top to bottom, and 3 draws from bottom to top)
- `set_offset(x, y)` - set statbar offset
- `set_size(x, y)` - set statbar size
- `set_min(min)` - set statbar minimum
- `set_max(max)` - set statbar maximum
- `set_status(num)` - set number in between minimum and maximum to indicate how many halves of the specified texture should be shown
- `get_status()` - get status number

#### `add_statbar`
__Usage:__ `hudlib.add_waypoint(<player (userdata or string)>, <hud name (string)>, <definition (table)>)`

Adds a statbar HUD element and returns the helper table described in the `get_waypoint` documentation above. Automatically sets the type of the element. The statbar text can be set with the `texture` attribute, the minimum/maximum/start number of halves of the specified texture to display can be set with the `min`/`max`/`start` attributes. See documentation for `add` in `HUD.md` for information on other custom attributes.