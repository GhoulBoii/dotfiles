-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")

require("core.bar")
require("core.binds")
require("core.noti")
require("core.rules")
require("core.sig")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/pywal.lua")
