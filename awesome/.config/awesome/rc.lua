-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local sh = awful.util.spawn_with_shell

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- {{{ Naughty config
naughty.config.defaults.timeout = 7
naughty.config.defaults.icon_size = 32
naughty.config.defaults.gap = 10
naughty.config.defaults.margin = 5
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
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/cheesy/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "/usr/local/bin/st"
editor = "/usr/bin/vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
	awful.layout.suit.tile,
	awful.layout.suit.floating
}
-- }}}
-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end
-- }}}
-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}
-- {{{ Menu
-- Create a laucher widget and a main menu
menu_awesome = {
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit }
}

menu_root = awful.menu({
	items = {
		{ "awesome", menu_awesome, beautiful.awesome_icon },
		{ "open terminal", terminal }
	}
})

launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = menu_root
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock("%I:%M:%S %p %m/%d/%Y")

batterywidget = wibox.widget.textbox()
batterywidget:set_text("Battery")
batterywidgettimer = timer({ timeout = 5 })
batterywidgettimer:connect_signal("timeout",
  function()
    fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))
    batterywidget:set_text(" |" .. fh:read("*l") .. " | ")
    fh:close()
  end
)
batterywidgettimer:start()

-- Create a wibox for each screen and add it
container_box = {} -- Entire wibox.
prompt_boxes = {}  -- Table of prompt boxes.
layout_boxes = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag),
awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
	if c == client.focus then
		c.minimized = true
	else
		-- Without this, the following
		-- :isvisible() makes no sense
		c.minimized = false
		if not c:isvisible() then
			awful.tag.viewonly(c:tags()[1])
		end
		-- This will also un-minimize
		-- the client, if needed
		client.focus = c
		c:raise()
	end
end),
-- awful.button({ }, 3, function ()
-- 	if instance then
-- 		instance:hide()
-- 		instance = nil
-- 	else
-- 		instance = awful.menu.clients({
-- 			theme = { width = 250 }
-- 		})
-- 	end
-- end),
awful.button({ }, 4, function ()
	awful.client.focus.byidx(1)
	if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	prompt_boxes[s] = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- By default, it's in the top right corner.
	-- We need one layoutbox per screen.
	layout_boxes[s] = awful.widget.layoutbox(s)
	layout_boxes[s]:buttons(
		awful.util.table.join(
			awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
			awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
			awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
			awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)
		)
	)

	-- Create a taglist widget. It contains the list of tags.
	mytaglist[s] = awful.widget.taglist(
		s, awful.widget.taglist.filter.all, mytaglist.buttons
	)

	-- Create a tasklist widget. It contains a list of tasks.
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	container_box[s] = awful.wibox({ position = "top", screen = s })

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(mytaglist[s])
	left_layout:add(prompt_boxes[s])

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(mytextclock)
	right_layout:add(batterywidget)
	right_layout:add(layout_boxes[s])

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	container_box[s]:set_widget(layout)
end
-- }}}
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () menu_root:toggle() end),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ Key bindings
globalkeys = awful.util.table.join(
	-- Go to the last visited tag. (Switch back and forth.)
	awful.key({ modkey }, "Escape", awful.tag.history.restore),

	awful.key({ }, "XF86AudioRaiseVolume", function()
		sh("amixer set Master 3%+")
	end),
	awful.key({ }, "XF86AudioLowerVolume", function()
		sh("amixer set Master 3%-")
	end),
	awful.key({ }, "XF86AudioMute", function()
		sh("amixer set Master toggle")
	end),
	awful.key({ }, "Print", function()
		sh("maim -s --nokeyboard ~/Screenshots/$(date +%F-%T.png)")
	end),

	-- Change focus of clients.
	awful.key({ modkey }, "j",
	function()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey }, "k",
	function()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end),

	-- Show menu.
	awful.key({ modkey, "Shift" }, "m", function() menu_root:show() end),

	-- Layout manipulation.
	-- Mod+Shift+[H/L]: Swap this client with another one..
	awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.byidx(  1) end),
	awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.byidx( -1) end),

	-- Used for focusing other screens, but I only have one, so this is unused.
	-- awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative( 1) end),
	-- awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end),
	
	-- Jump to urgent client.
	awful.key({ modkey }, "u", awful.client.urgent.jumpto),

	-- Focus between last client and current client.
	awful.key({ modkey }, "Tab",
	function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),

	-- Spawn a terminal.
	awful.key({ modkey,           }, "Return", function() awful.util.spawn(terminal) end),

	-- Restart/quit awesome.
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	-- Change the width of the master column.
	awful.key({ modkey,           }, "l",     function() awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey,           }, "h",     function() awful.tag.incmwfact(-0.05)    end),

	-- Change the amount of clients in the master column.
	awful.key({ modkey, "Shift"   }, "[",     function() awful.tag.incnmaster(-1)      end),
	awful.key({ modkey, "Shift"   }, "]",     function() awful.tag.incnmaster(1)      end),

	-- Change the amount of other columns.
	awful.key({ modkey, "Control" }, "[",     function() awful.tag.incncol(-1)         end),
	awful.key({ modkey, "Control" }, "]",     function() awful.tag.incncol(1)         end),

	-- Switch between layouts using Mod+Space and Mod+Shift+Space.
	awful.key({ modkey,           }, "space", function() awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(layouts, -1) end),

	-- Un-minimizes a random client.
	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- Program launching.
	-- Mod+R: Launch a prompt box, launch any program by name.
	-- Mod+P: Launch an application launcher, like dmenu.
	awful.key({ modkey }, "r", function() prompt_boxes[mouse.screen]:run() end),
	awful.key({ modkey }, "p", function() menubar.show() end),
	awful.key({ modkey }, "x",
		function ()
				awful.prompt.run({ prompt = "Run Lua code: " },
				prompt_boxes[mouse.screen].widget,
				awful.util.eval, nil,
				awful.util.getdir("cache") .. "/history_eval")
		end)
)

-- Keys that applies to clients.
clientkeys = awful.util.table.join(
	-- Toggle fullscreen.
	awful.key({ modkey,           }, "f",      function(c) c.fullscreen = not c.fullscreen end),

	-- Kill.
	awful.key({ modkey,           }, "w",      function(c) c:kill() end),

	-- Toggle floating.
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),

	-- Swap this client with the master client.
	awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
	-- awful.key({ modkey,           }, "o",      awful.client.movetoscreen),
	
	-- Toggle ontop.
	awful.key({ modkey,           }, "t",      function(c) c.ontop = not c.ontop end),

	-- Minimize this client.
	-- Unminimize a random one with Mod+Ctrl+N.
	awful.key({ modkey,           }, "n",
	function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end),

	-- Toggles maximization of a client.
	awful.key({ modkey,           }, "m",
	function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewonly(tag)
		end
	end),
	-- Toggle tag.
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end),
	-- Move client to tag.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.movetotag(tag)
			end
		end
	end),
	-- Toggle tag.
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.toggletag(tag)
			end
		end
	end))
end

clientbuttons = awful.util.table.join(
	-- Focus a client by clicking on it.
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),

	-- Hold down Mod+Mouse1 to move a client using the mouse.
	awful.button({ modkey }, 1, awful.mouse.client.move),

	-- Hold down Mod+Mouse2 to resize a client using the mouse.
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons
		}
	},

	-- Make certain applications float.
	-- I usually keep Gimp in single window mode.
	{ rule = { class = "pinentry" },
	properties = { floating = true } },
	{ rule = { class = "gimp" },
	properties = { floating = true } },
	{ rule = { class = "kilo2" },
	properties = { floating = true } },

	-- Keep Google Chrome on tag 2.
	{ rule = { class = "google-chrome" }, properties = { tag = tags[1][2] } },

	-- Keep Discord on tag 3.
	{ rule = { class = "discord" }, properties = { tag = tags[1][3] } }
}
-- }}}
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	c:connect_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	local titlebars_enabled = false
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		-- buttons for the titlebar
		local buttons = awful.util.table.join(
		awful.button({ }, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
		)

		-- Widgets that are aligned to the left
		local left_layout = wibox.layout.fixed.horizontal()
		left_layout:add(awful.titlebar.widget.iconwidget(c))
		left_layout:buttons(buttons)

		-- Widgets that are aligned to the right
		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(awful.titlebar.widget.floatingbutton(c))
		right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		right_layout:add(awful.titlebar.widget.stickybutton(c))
		right_layout:add(awful.titlebar.widget.ontopbutton(c))
		right_layout:add(awful.titlebar.widget.closebutton(c))

		-- The title goes in the middle
		local middle_layout = wibox.layout.flex.horizontal()
		local title = awful.titlebar.widget.titlewidget(c)
		title:set_align("center")
		middle_layout:add(title)
		middle_layout:buttons(buttons)

		-- Now bring it all together
		local layout = wibox.layout.align.horizontal()
		layout:set_left(left_layout)
		layout:set_right(right_layout)
		layout:set_middle(middle_layout)

		awful.titlebar(c):set_widget(layout)
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- {{{ Shell autostart
-- No touchpad, please.
sh("xinput disable 13")
-- }}}
