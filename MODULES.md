# Modules
Modules allow HUD Plus to be divided into different parts which can be enabled or disabled using the configuration file (as documented below). We use this as an alternative to a simple modpack to prevent cluttering the list provided by `/mods` and as it allows for this mod to be distributed in another modpack. If you are considering contributing to this mod, you will likely find it worthwhile to read this short documentation on the modules API.

## Managing Modules
Modules listed in the configuration file are automatically loaded at startup unless specifically disabled. For the purpose of listing and/or disabling mods, we've introduced the `modules.conf` file.

Each module is listed on a new line, as if setting a variable. A module can be disabled or enabled by setting this variable to `true` or `false`. If a module is set to `false` (disabled), it will not be automatically loaded. __Note:__ modules will be loaded anyway if they are not found in the configuration file at all.

__Example:__
```lua
-- Enabled:
storage = true
-- Disabled:
storage = false
```

A small API is provided allowing modules to be loaded from another module or from the main API. A module can be force loaded (overrides configuration), or can be loaded with the configuration in mind.

## Module API
Modules are places a subdirectories of the `modules` directory. Each module must have the same name as its reference in the configuration file. Modules must have an `init.lua` file, where you can load other portions of the module with `dofile`, or use the API documented below.

#### `get_module_path(name)`
__Usage:__ `hudplus.get_module_path(<module name (string)>)`

Returns the full path of the module or `nil` if it does not exist. This can be used to check for another module, or to easily access the path of the current module in preparation to load other files with `dofile` or the likes.

#### `load_module(name)`
__Usage:__ `hudplus.load_module(<module name (string)>)`

Attempts to load a module. If the module path is `nil`, `nil` is returned to indicate that the module does not exist. Otherwise, a return value of `true` indicates a success or that the module has already been loaded. __Note:__ this function overrides any settings in `modules.conf`, meaning that it will be loaded even if it was disabled. For general use cases, use `require_module` instead.

#### `require_module(name)`
__Usage:__ `hudplus.require_module(<module name (string)>)`

Passes name to `load_module` if the mod was not disabled in `modules.conf`. For further documentation, see `load_module`.
