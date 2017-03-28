# Main API
The main API (`api.lua`) registers but a few functions allowing you to do things like view all the HUD elements attached to a player no matter their type or execute some code after a specific amount of time. Each function provided by this API is documented below.

#### `after`
__Usage:__ `hudlib.after(<name (string)>, <time (integer)>, <func (function)>)`

This is a nearly drop-in replacement for `minetest.after`, except it can be considered to be slightly more advanced. It uses global steps instead, which are also considered more reliable. The most important change, is that things queued with `after` are placed in a queue table under the name specified. This means that if `after` is called specifying the same name, the time will be updated and the counter reset preventing HUDs and other things from disappearing too quickly in the case of `minetest.after` where calls would get stacked up.

#### `after_remove`
__Usage:__ `hudlib.after_remove(<name (string)>)`

Remove an after call from the queue so that it will not be called when its time is up. After calls using HUD Library' after function are queued by name. See `after` for more information.

#### `parse_time`
__Usage:__ `hudlib.parse_time(<time (string)>)`

Parses a string containing sets separated by spaces, each containing any amount of numbers and one alpha-numeric character. You can have as many sets as you want, each one representing either a second, minute, or hour. If no alpha-numeric character follows a set or it is followed by `s`, it is intepreted as seconds. If `m` follows a set, it is intepreted as minutes, while `h` is intepreted as hours. If an integer is provided to `parse_time`, it will simply be returned without undergoing any processing. See below for example.

```lua
hudlib.parse_time("10m 1h 23s 5")
-- ^ returns 4228 seconds
```

#### `event`
__Usage:__ `hudlib.event(<player (userdata or string)>, <event name (string)>, <hud (table)>, ...)`

This is used for easier handling of events. It accepts a player name to be provided to the event function, the name of the event, a table containing the entire HUD entry, and a variable number of other parameters to be provided to the event function.

__Valid Events:__
- `add`
- `remove`
- `change`
- `show`
- `hide`
- `step`
- `every`
