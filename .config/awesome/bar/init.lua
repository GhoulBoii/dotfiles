local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local mod = require("binds.mod")

_M.separator = wibox.widget {
  wibox.widget.textbox("|"),
  fg = beautiful.fg_normal,
  widget = wibox.container.background
}

-----------
-- CLOCK --
-----------

_M.clock = wibox.widget {
  widget = wibox.widget.textbox
}

local function update_clock(clock)
  _M.clock.text = clock
end

gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
      awful.spawn.easy_async_with_shell("sb-clock", function (stdout)
        update_clock(stdout)
      end)
  end
}

-------------
-- BATTERY --
-------------

_M.battery = wibox.widget {
    widget = wibox.widget.textbox
}

local function update_battery(bat)
  _M.battery.text = bat
end

gears.timer {
  timeout   = 30,
  call_now  = true,
  autostart = true,
  callback  = function()
      awful.spawn.easy_async_with_shell("sb-battery", function (stdout)
        update_battery(stdout)
      end)
  end
}

------------
-- VOLUME --
------------

_M.volume = wibox.widget {
    widget = wibox.widget.textbox
}

local function update_volume(vol)
  _M.volume.text = vol
end

gears.timer {
  timeout   = 0.1,
  call_now  = true,
  autostart = true,
  callback  = function()
      awful.spawn.easy_async_with_shell("sb-volume", function (stdout)
        update_volume(stdout)
      end)
  end
}

function _M.create_promptbox() return awful.widget.prompt() end

function _M.create_taglist(s)
   return awful.widget.taglist{
      screen = s,
      filter  = awful.widget.taglist.filter.noempty,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function(t) t:view_only() end,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 1,
            on_press  = function(t)
               if client.focus then
                  client.focus:move_to_tag(t)
               end
            end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = awful.tag.viewtoggle,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 3,
            on_press  = function(t)
               if client.focus then
                  client.focus:toggle_tag(t)
               end
            end
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function(t) awful.tag.viewprev(t.screen) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function(t) awful.tag.viewnext(t.screen) end,
         },
      }
   }
end

function _M.create_tasklist(s)
   return awful.widget.tasklist{
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function(c)
               c:activate{context = 'tasklist', action = 'toggle_minimization'}
            end,
         },
      }
   }
end

function _M.create_wibox(s)
   return awful.wibar{
      screen = s,
      position = 'top',
      height = 20,
      margins = {
        top = 20,
        left = 20,
        right = 20,
      },

      widget = {
         layout = wibox.layout.align.horizontal,
         -- left widgets
         {
            layout = wibox.layout.fixed.horizontal,
            s.taglist,
            s.promptbox,
         },
         -- middle widgets
         s.tasklist,
         -- right widgets
         {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(10),
            _M.volume,
            _M.separator,
            _M.battery,
            _M.separator,
            _M.clock,
            wibox.widget.systray(),
         }
      }
   }
end

return _M
