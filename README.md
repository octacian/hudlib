![Screenshot](.gh-screenshot.png)

HUD Library [hudlib]
====================

* Version: 0.1, beta
* License: MIT (see [LICENSE](https://github.com/octacian/hudlib/blob/master/LICENSE))

HUDLib aims to create a very simple and easy to use API in front of a powerful and complex backend. Sure, there are other mods that introduce APIs to simplify HUD development, but they all focus on some type of statbar (used for things like health) and don't support other HUD elements. However, HUDLib will support all available HUD elements (including statbars and waypoints), wrapping them in an API built to lessen the amount of code you need to make your HUD not only look nice but also be functional.

### Why HUDLib?
When stacked up against other HUD libraries, HUDLib excels in that it supports all HUD elements and has an intuitive API allowing you to do more with less code (see features for more information). However, how does it stack up compared to the default Minetest HUD API?

- HUDs are identified by a name chosen by the modder rather than by arbitrary IDs
- HUDLib supports hiding/showing HUDs without entirely removing them add having to redefine them manually
- HUDs can be registered that will be shown to all players
- HUDs can be removed from all players with one line of code
- All of the HUDs attached to a specific player can be retrieved, including specifics about each HUD (e.g. original definition table, visibility, etc...)
- Callbacks can be added to the HUD definition to be automatically called (e.g. on_step, on_hide, etc...) not unlike those supported within node definitions
- HUDs can be automatically hidden by defining `hide_after` in the HUD definition
- ...and more!

### Features
- `hudlib.after` which uses a named queueing system replaces `minetest.after`
- HUDs are referenced by a name chosen by the modder
- Hiding/Showing HUDs without having to redefine the HUD
- Showing an HUD to all players
- Removing an HUD from all players
- Auto-hiding HUDs
- Callbacks in HUD definition
  - on_step
  - on_show
  - on_hide
- List all HUDs attached to a player

### Planned
- Statbar API
- Waypoint API
- Custom APIs for each element type
- Parent-Child Constraints (e.g. the child's position is made relative to the parent's)
- Auto-repositioning of HUDs to avoid overlap (?)

### API
For information on the API available for use by other mods (this is the API used by HUD Plus), see [API.md](https://github.com/octacian/hudlib/blob/master/API.md).

### Download
[Master](https://github.com/octacian/hudlib/archive/master.zip) (latest, often unstable)<br>
[Version 0.1](https://github.com/octacian/hudlib/archive/v0.1.zip) (latest, stable)<br>
...or View all releases on [GitHub](https://github.com/octacian/hudlib/releases)

__Note:__ HUDLib does not register any HUDs, but only provides an API. If you'd like to see how HUDLib can be used, see [HUD Plus](https://forum.minetest.net/viewtopic.php?f=9&t=16864), the mod in which this API was originally developed.

Choose one of the downloads above and extract the ZIP. Though it is recommended, you are not required to rename the resulting directory to `hudlib`. If you are not sure what to choose, look for the first version labeled as "latest, stable."
