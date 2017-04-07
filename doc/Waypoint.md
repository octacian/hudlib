# Waypoints
The API for waypoint HUD elements is based off of the main API, however, it makes things even easier when it comes to manipulating the waypoint HUDs. The main reason why this sub-API makes things easier, is that it presents a table for each waypoint element, suited with several functions to manipulate it without requiring that the identification of the element be provided each time you make a change.

#### `list_waypoints`
__Usage:__ `hudlib.list_waypoints(<player (userdata or string)>)`

Lists all waypoint elements attached to a player.

#### `get_waypoint`
__Usage:__ `hudlib.get_waypoint(<player (userdata or string)>, <hud name (string)>)`

Returns a table containing all of the helpers which allow manipulation of the text element. Helpers can be called in this method: `hudlib.get_waypoint(...):remove()` (see below for all available helpers).

__Helpers:__
- `remove()` - removes the waypoint HUD element
- `hide()` - hides the waypoint
- `show()` - shows the waypoint (if it is hidden)
- `set_name(name)` - sets name of waypoint (will be shown to player)
- `set_suffix(string)` - sets the text to be shown after the distance
- `set_colour(colour)` or `set_color(color)` - sets the colour of the waypoint (`colour` or `color` is "An integer containing the RGB value of the color used to draw the text. Specify 0xFFFFFF for white text, 0xFF0000 for red, and so on.")
- `set_pos(position table)` - sets the waypoint target position
- `set_max(number)` - sets the maximum distance a player can be from the waypoint before it is hidden

#### `add_waypoint`
__Usage:__ `hudlib.add_waypoint(<player (userdata or string)>, <hud name (string)>, <definition (table)>)`

Adds a waypoint HUD element and returns the helper table described in the `get_waypoint` documentation above. Automatically sets the type of the element. The waypoint text colour may be specified with either the `colour` or `color` attributes rather than the `number` attribute. The suffix (to be shown after the distance) can be set with the `suffix` rather than `text` attribute. The target position of the waypoint can be set with the `pos` attribute rather than `world_pos`. A custom attribute called `max` is also introduced, which causes the waypoint to be hidden from the player once he/she reaches a distance larger than that specified by `max`. See documentation for `add` in `HUD.md` for information on other custom attributes.