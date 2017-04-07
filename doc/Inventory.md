# Inventory Elements
The API for inventory HUD elements is based off of the main API, however, it makes things even easier when it comes to manipulating the inventory HUDs. The main reason why this sub-API makes things easier, is that it presents a table for each inventory element, suited with several functions to manipulate it without requiring that the identification of the element be provided each time you make a change.

#### `list_inv`
__Usage:__ `hudlib.list_inv(<player (userdata or string)>)`

Lists all inventory elements attached to a player.

#### `get_inv`
__Usage:__ `hudlib.get_inv(<player (userdata or string)>, <hud name (string)>)`

Returns a table containing all of the helpers which allow manipulation of the inventory element. Helpers can be called in this method: `hudlib.get_inv(...):remove()` (see below for all available helpers).

__Helpers:__
- `remove()` - removes the inventory HUD element
- `hide()` - hides the inventory
- `show()` - shows the inventory (if it is hidden)
- `set_pos(x, y)` - sets the position of the inventory
- `set_name(name)` - changes the inventory shown
- `set_number(number)` - sets number of items shown
- `set_item(number)` - sets selected item
- `set_dir(number)` - sets direction in which inventory is drawn

#### `add_inv`
__Usage:__ `hudlib.add_inv(<player (userdata or string)>, <hud name (string)>, <definition (table)>)`

Adds an inventory HUD element and returns the helper table described in the `get_inv` documentation above. Automatically sets the type of the element. The inventory name may be specified by the `name` rather than `text` attribute. See documentation for `add` in `HUD.md` for information on other custom attributes.