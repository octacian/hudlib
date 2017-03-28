# Images
The API for image HUD elements is based off of the main API, however, it makes things even easier when it comes to manipulating the image HUDs. The main reason why this sub-API makes things easier, is that it presents a table for each image, suited with several functions to manipulate it without requiring that the identification of the image be provided each time you make a change.

#### `list_images`
__Usage:__ `hudlib.list_images(<player (userdata or string)>)`

Lists all image HUDs attached to a player.

#### `get_image`
__Usage:__ `hudlib.get_image(<player (userdata or string)>, <hud name (string)>)`

Returns a table containing all of the helpers which allow manipulation of the image. Helpers can be called in this method: `hudlib.get_image(...).remove()` (see below for all available helpers).

__Helpers:__
- `remove()` - removes the image HUD element
- `hide()` - hides the image
- `show()` - shows the image (if it is hidden)
- `set_pos(x, y)` - sets the position of the image
- `set_scale(x, y)` - sets the scale of the image
- `set_image(name)` - changes the image
- `set_alignment(x, y)` - aligns image
- `set_offset(x, y)` - sets positional offset of the image

#### `add_image`
__Usage:__ `hudlib.add_image(<player (userdata or string)>, <hud name (string)>, <definition (table)>)`

Adds an image HUD element and returns the helper table described in the `get_image` documentation above. Automatically sets the type of the element. The image name is not specified with `text`, but rather with the `image` attribute. See documentation for `add` in `HUD.md` for information on other custom attributes.