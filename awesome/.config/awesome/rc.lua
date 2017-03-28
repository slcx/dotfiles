-- vim: set ts=4 sw=4 sts=4:
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- third party
local battery_widget = require("battery-widget")

-- make icon size 64 pixels big
naughty.config.defaults.icon_size = 64

-- run something in bash
function sh(cmd)
    return awful.util.spawn_with_shell("bash -c \"" .. cmd .. "\"")
end

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
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = "nvim-qt"
www_cmd = "chromium"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating
}
-- }}}
-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}
-- {{{ Menu
-- Create a launcher widget and a main menu
awesome_menu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "docs", www_cmd .. " " .. "https://awesomewm.org/apidoc/" },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({
    items = {
        { "awesome", awesome_menu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%m/%d %I:%M:%S %p", 1)

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, client_menu_toggle_fn()),
    awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
    awful.button({ }, 5, function() awful.client.focus.byidx(1) end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    local battery = battery_widget({adapter="BAT0"})

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.layout.inc( 1) end),
        awful.button({ }, 3, function() awful.layout.inc(-1) end),
        awful.button({ }, 4, function() awful.layout.inc( 1) end),
        awful.button({ }, 5, function() awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s,
        awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            battery.widget,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function() mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))
-- }}}
-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- show help gui
    awful.key({ modkey }, "s", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- volume
    awful.key({ modkey }, "]", function()
        sh("amixer set Master 3%+")
    end, {description="raise volume", group="system"}),
    awful.key({ modkey }, "[", function()
        sh("amixer set Master 3%-")
    end, {description="lower volume", group="system"}),
    awful.key({ modkey }, "\\", function()
        sh("amixer set Master toggle")
    end, {description="toggle volume", group="system"}),

    -- brightness
    awful.key({ modkey }, "'", function()
        sh("xbacklight -inc 5")
    end, {description="increase brightness", group="system"}),
    awful.key({ modkey }, ";", function()
        sh("xbacklight -dec 5")
    end, {description="lower brightness", group="system"}),

    -- screenshot
    awful.key({ }, "Print", function()
        sh("~/bin/snap")
    end),

    -- focus by direction
    awful.key({ modkey }, "h",
        function() awful.client.focus.bydirection("left") end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "j",
        function() awful.client.focus.bydirection("down") end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function() awful.client.focus.bydirection("up") end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "l",
        function() awful.client.focus.bydirection("right") end,
        {description = "focus right", group = "client"}),

    -- layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"}, "k", function() awful.client.swap.byidx(-1) end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end,
        {description = "go back", group = "client"}
    ),

    -- Standard program
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol( 1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(-1, nil, true) end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey }, "space", function() awful.layout.inc(1) end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- focus restored client
            if c then client.focus = c; c:raise() end
        end,
        {description = "restore minimized", group = "client"}
    ),

    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}
    ),
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {description = "toggle fullscreen", group = "client"}),

    -- close
    awful.key({ modkey }, "w", function (c) c:kill() end,
              {description = "close", group = "client"}),

    -- toggle floating
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey }, "o", function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey }, "n", function(c) c.minimized = true end,
        {description = "minimize", group = "client"}),
    awful.key({ modkey }, "m", function(c) c.maximized = not c.maximized; c:raise() end,
        {description = "maximize", group = "client"})
)

-- bind all key numbers to tags
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- view tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}
        ),
        -- move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}
        )
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = clientkeys,
          buttons = clientbuttons,
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap + awful.placement.no_offscreen
      }
    },

    { rule_any = {
        instance = { "DTA", "copyq" },
        class = { "Arandr", "Gpick", "Kruler", "MessageWin", "Sxiv", "Wpa_gui",
          "pinentry", "veromix", "xtightvncviewer"},
        name = { "Event Tester" },
        role = { "AlarmWindow", "pop-up" }
      }, properties = { floating = true }},

    { rule_any = { class = { "st-256color" } },
      properties = { size_hints_honor = false } },

    {
        -- rule_any = {type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true } },

    { rule_any = { class = { "chromium", "Chromium" } },
      properties = { tag = "2" } },
    { rule = { class = "discord" },
      properties = { tag = "3" } },
    { rule = { class = "Gimp-2.8" },
      properties = { tag = "5" } },
    { rule_any = { class = { "Mail", "Thunderbird" } },
      properties = { tag = "4" } },
    { rule_any = { class = { "Client.pyw", "client.pyw" }, name = { "hydrus client" } },
      properties = { tag = "6" } },
    { rule_any = { class = { "Steam", "steam" }, name = { "Steam Login" } },
      properties = { tag = "9" } },
}
-- }}}
-- {{{ Signals
-- signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
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

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- Autostart {{{
sh("xinput disable 13")
sh("setxkbmap -option caps:escape")

function create_bash_macro(process_name)
    return "bash -c \"if pgrep " .. process_name .. " >/dev/null; then echo 1; fi\""
end

function autostart(process, process_name)
    local is_running = function(name)
        local result = io.popen(create_bash_macro(process_name)):read()
        if result == "1" then return true end
    end
    if is_running(process_name) then
        return
    end
    sh(process)
end

autostart("chromium", "chromium")
autostart("discord-canary", "DiscordCanary")
autostart("thunderbird", "thunderbird")
-- }}}
