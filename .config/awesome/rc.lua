-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

--  Load Theme
local beautiful = require("beautiful")
local gears = require("gears")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/pywal.lua")

-- Load Bindings
require("binds")

-- Load Rules
require("rules")

-- Load Signals
require("sig")
