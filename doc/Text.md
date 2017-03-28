# Text Elements
The API for text HUD elements is based off of the main API, however, it makes things even easier when it comes to manipulating the text HUDs. The main reason why this sub-API makes things easier, is that it presents a table for each text element, suited with several functions to manipulate it without requiring that the identification of the element be provided each time you make a change.

#### `list_text`
__Usage:__ `hudlib.list_text(<player (userdata or string)>)`

Lists all text elements attached to a player.

#### `get_text`
__Usage:__ `hudlib.get_text(<player (userdata or string)>, <hud name (string)>)`

Returns a table containing all of the helpers which allow manipulation of the text element. Helpers can be called in this method: `hudlib.get_image(...).remove()` (see below for all available helpers).

__Helpers:__
- `remove()` - removes the text HUD element
- `hide()` - hides the text
- `show()` - shows the text (if it is hidden)
- `set_pos(x, y)` - sets the position of the text
- `set_scale(x, y)` - sets the scale of the text
- `set_text(name)` - changes the text
- `set_alignment(x, y)` - aligns text
- `set_offset(x, y)` - sets positional offset of the text
- `set_colour(colour)` or `set_color(color)` - sets the colour of the text (`colour` or `color` is "An integer containing the RGB value of the color used to draw the text. Specify 0xFFFFFF for white text, 0xFF0000 for red, and so on.")

#### `add_text`
__Usage:__ `hudlib.add_text(<player (userdata or string)>, <hud name (string)>, <definition (table)>)`

Adds a text HUD element and returns the helper table described in the `get_text` documentation above. Automatically sets the type of the element. The text colour may be specified with either the `colour` or `color` attributes rather than the `number` attribute. See documentation for `add` in `HUD.md` for information on other custom attributes.