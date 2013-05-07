-- {{{ Required Libraries

awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
beautiful       = require("beautiful")
naughty         = require("naughty")
cairo           = require("lgi").cairo
blingbling      = require("blingbling")
vicious         = require("vicious")
gears           = require("gears")
revelation      = require("revelation")
menubar         = require("menubar")

   menubar.cache_entries = false
   menubar.app_folders =
   {
     '/usr/share/applications/',
     --'/user/share/applications/kde4/',
     '/usr/local/share/applications/',
     '~/.local/share/applications'
   }
   menubar.show_categories = true

require("freedesktop.utils")
  --freedesktop.utils.terminal = terminal
  freedesktop.utils.icon_theme = "Faenza-Dark"
  freedesktop.utils.file_manager = "pantheon-files"
require("freedesktop.menu")

-- }}}

-- {{{ Autostart

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
 end 

 run_once("cbatticon")
 run_once("nitrogen --restore")
-- run_once("dropboxd")
 run_once("wicd-gtk --tray")
 --run_once("volwheel")
run_once("stjerm -s left -us ibeam -k F12 -o 50")

-- }}}


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/eric/.config/awesome/themes/awesome-solarized/dark/theme.lua")
config_dir = awful.util.getdir("config")

-- This is used later as the default terminal and editor to run.

terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "subl"
browser = "pantheon-files"
home = os.getenv("HOME")
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"



require("tags")
require("menu")
require("widgets")
require("bindings")
require("rules")
