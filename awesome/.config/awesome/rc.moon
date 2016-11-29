-- standard awesome library
gears = require "gears"
awful = require "awful"
awful.rules = require "awful.rules"
sh = awful.util.spawn_with_shell

package.path ..= ";/home/cheesy/.config/awesome/?.lua"
import transform from require "transformer.keymapper"

require "awful.autofocus"

-- widget and layout library
wibox = require "wibox"

-- theme handling library
beautiful = require "beautiful"

-- notification library
naughty = require "naughty"
menubar = require "menubar"

-- open the log file
home = os.getenv "HOME"
log_file = io.open "#{home}/.awesome_startup.log", "a"
log = (text) -> log_file\write text, "\n"

log "*** Awesome startup. [#{os.date!}] ***"
-- {{{ Naughty config
with naughty.config.defaults
  .timeout = 7
  .icon_size = 32
  .gap = 10
  .margin = 5
-- }}}
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors
  naughty.notify {
    preset: naughty.config.presets.critical
    title: "Oops, there were errors during startup!"
    text: awesome.startup_errors
  }

-- Handle runtime errors after startup
do
  in_error = false
  awesome.connect_signal "debug::error", (err) ->
    -- Make sure we don't go into an endless error loop
    return if in_error

    in_error = true
    naughty.notify {
      preset: naughty.config.presets.critical
      title: "Oops, an error happened!"
      text: err
    }
    in_error = false

-- }}}
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init "/home/cheesy/.config/awesome/theme.lua"

-- This is used later as the default terminal and editor to run.
terminal = "/usr/bin/st"
editor = "/usr/bin/nvim"
editor_cmd = "#{terminal} -e #{editor}"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating
}
-- }}}
-- {{{ Wallpaper
if beautiful.wallpaper
  for s = 1, screen.count!
    gears.wallpaper.maximized beautiful.wallpaper, s, true
-- }}}
-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count!
  -- Each screen has its own tag table.
  tags[s] = awful.tag {
    "code", "www", "chat", "mus", "art", "term", "term", "term", "game"
  }, s, layouts[1]
-- }}}
-- {{{ Menu
-- Create a laucher widget and a main menu
menu_awesome = {
  { "manual", terminal .. " -e man awesome" }
  { "edit config", "#{editor_cmd} #{awesome.conffile}" }
  { "restart", awesome.restart }
  { "quit", awesome.quit }
}

menu_root = awful.menu {
  items: {
    { "awesome", menu_awesome, beautiful.awesome_icon }
    { "open terminal", terminal }
  }
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
-- {{{ Wibox
-- Create a textclock widget
log ">>> Phase: wibox"
mytextclock = awful.widget.textclock "%I:%M:%S %p %m/%d/%Y %a", 1

batterywidget = wibox.widget.textbox!
batterywidget\set_text ""
batterywidgettimer = timer timeout: 5
batterywidgettimer\connect_signal "timeout", ->
    fh = assert io.popen "acpi | cut -d, -f 2,3 -", "r"
    batterywidget\set_text "#{fh\read("*l")}"
    fh\close!
batterywidgettimer\start!

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
  awful.button({ }, 5, (t) -> awful.tag.viewnext(awful.tag.getscreen(t))),
  awful.button({ }, 4, (t) -> awful.tag.viewprev(awful.tag.getscreen(t)))
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button { }, 1, (c) ->
    if c == client.focus
      c.minimized = true
    else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      unless c\isvisible!
        awful.tag.viewonly c\tags![1]
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c\raise!
  awful.button { }, 4, ->
    awful.client.focus.byidx 1
    client.focus\raise! if client.focus
  awful.button { }, 5, ->
    awful.client.focus.byidx(-1)
    client.focus\raise! if client.focus
)

for s = 1, screen.count!
  -- Create a promptbox for each screen
  prompt_boxes[s] = awful.widget.prompt!

  -- shows the current layout
  layout_boxes[s] = awful.widget.layoutbox(s)

  -- Create a taglist widget. It contains the list of tags.
  mytaglist[s] = awful.widget.taglist(
    s, awful.widget.taglist.filter.all, mytaglist.buttons
  )

  -- Create a tasklist widget. It contains a list of tasks.
  mytasklist[s] = awful.widget.tasklist(
    s,
    awful.widget.tasklist.filter.currenttags,
    mytasklist.buttons
  )

  -- Create the wibox
  container_box[s] = awful.wibox position: "top", screen: s

  -- wraps a widget in a horizontal margin
  horiz_margin_wrap = (widget, left = 5, right = 5) ->
    margin = wibox.layout.margin!
    with margin
      \set_widget widget
      \set_left left
      \set_right right
    margin

  left_layout = wibox.layout.fixed.horizontal!
  left_layout\add mytaglist[s]
  left_layout\add prompt_boxes[s]

  right_layout = wibox.layout.fixed.horizontal!
  right_layout\add horiz_margin_wrap(wibox.widget.systray!, 0, 5)
  right_layout\add mytextclock
  right_layout\add horiz_margin_wrap(batterywidget, 0, 5)
  right_layout\add layout_boxes[s]

  layout = wibox.layout.align.horizontal!
  layout\set_left left_layout
  layout\set_middle mytasklist[s]
  layout\set_right right_layout

  container_box[s]\set_widget layout
-- }}}
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, -> menu_root\toggle!),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ Key bindings

-- focus by direction
fbd = (d) ->
  awful.client.focus.bydirection d
  client.focus\raise! if client.focus

-- global keys
gk = transform
  [modkey]:
    -- go to the last visited tag.
    Escape: awful.tag.history.restore

    r: -> prompt_boxes[mouse.screen]\run!
    p: -> menubar.show!
    x: ->
      awful.prompt.run(
        prompt: "Run Lua code: ",
        prompt_boxes[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval"
      )

    u: awful.client.urgent.jumpto

    h: -> fbd "left"
    j: -> fbd "down"
    k: -> fbd "up"
    l: -> fbd "right"

    space: -> awful.layout.inc layouts, 1

    Tab: ->
      awful.client.focus.history.previous!
      client.focus\raise! if client.focus

    Return: -> awful.util.spawn terminal

    Shift:
      m: -> menu_root\show!
      h: -> awful.client.swap.byidx 1
      l: -> awful.client.swap.byidx -1

      -- Change amount of master columns.
      "[": -> awful.tag.incnmaster -1
      "]": -> awful.tag.incnmaster 1

      space: -> awful.layout.inc layouts, -1

    Control:
      r: awesome.restart
      q: awesome.quit

      n: awful.client.restore

      -- Change amount of other columns.
      "[": -> awful.tag.incncol -1
      "]": -> awful.tag.incncol 1

  XF86AudioRaiseVolume: -> sh "amixer set Master 3%+"
  XF86AudioLowerVolume: -> sh "amixer set Master 3%-"
  XF86AudioMute:        -> sh "amixer set Master toggle"
  Print:                -> sh "maim -s --nokeyboard ~/Screenshots/$(date +%F-%T.png)"

  -- Used for focusing other screens, but I only have one, so this is unused.
  -- awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative( 1) end),
  -- awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end),

globalkeys = awful.util.table.join(unpack gk)

-- Keys that are applied to each client.
ck = transform
  [modkey]:
    f: (c) -> c.fullscreen = not c.fullscreen
    w: (c) -> c\kill!
    t: (c) -> c.ontop = not c.ontop
    n: (c) -> c.minimized = true
    m: (c) ->
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical   = not c.maximized_vertical
    Control:
      space: awful.client.floating.toggle
      Return: (c) -> c\swap awful.client.getmaster!

clientkeys = awful.util.table.join(unpack ck)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9
  tk = {
    -- View tag only.
    awful.key { modkey }, "#" .. i + 9, ->
      screen = mouse.screen
      tag = awful.tag.gettags(screen)[i]
      awful.tag.viewonly tag if tag

    -- Toggle tag.
    awful.key { modkey, "Control" }, "#" .. i + 9, ->
      screen = mouse.screen
      tag = awful.tag.gettags(screen)[i]
      awful.tag.viewtoggle(tag) if tag

    awful.key { modkey, "Shift" }, "#" .. i + 9, ->
      return unless client.focus
      tag = awful.tag.gettags(client.focus.screen)[i]
      awful.client.movetotag(tag) if tag

    -- Toggle tag.
    awful.key { modkey, "Control", "Shift" }, "#" .. i + 9, ->
      return unless client.focus
      tag = awful.tag.gettags(client.focus.screen)[i]
      awful.client.toggletag(tag) if tag
  }
  tagkeys = awful.util.table.join(unpack tk)
  globalkeys = awful.util.table.join(globalkeys, tagkeys)

cb = {
  -- Focus a client by clicking on it.
  awful.button { }, 1, (c) ->
      client.focus = c
      c\raise!

  -- Hold down Mod+Mouse1 to move a client using the mouse.
  awful.button { modkey }, 1, awful.mouse.client.move

  -- Hold down Mod+Mouse2 to resize a client using the mouse.
  awful.button { modkey }, 3, awful.mouse.client.resize
}

clientbuttons = awful.util.table.join(unpack cb)

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule: {}
    properties: {
      border_width: beautiful.border_width
      border_color: beautiful.border_normal
      focus: awful.client.focus.filter
      raise: true
      keys: clientkeys
      buttons: clientbuttons } }

  -- Make certain applications float.
  { rule_any: {
    class: { "pinentry", "gimp" },
    properties: floating: true } }

  -- Keep browser on tag 2.
  { rule_any: class: {
      "Google-chrome", "google-chrome", "Chromium", "chromium",
      "google-chrome-beta", "Google-chrome-beta"
    }
    properties: tag: tags[1][2] }

  -- Keep chats on tag 3.
  {
    rule_any: {
      class: { "discord", "slack", "Slack", "TelegramDesktop",
        "telegram-desktop" }
      name: { "Slack - Toolbox Secret Group", "Discord" } }
    properties: tag: tags[1][3] }

  -- Keep Discord on tag 4.
  { rule: class: "Thunderbird", properties: tag: tags[1][4] }

  -- Keep the GIMP on tag 5.
  { rule: class: "gimp", properties: tag: tags[1][5] }

  -- Keep Steam on tag 9.
  {
    rule_any: {
      class: { "Steam", "steam" },
      name: { "Steam Login", "Steam" }
    }
    properties: tag: tags[1][9]
  }
}
-- }}}
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal "manage", (c, startup) ->
  -- Enable sloppy focus
  c\connect_signal "mouse::enter", (c) ->
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c)
      client.focus = c

  unless startup
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)

client.connect_signal("focus", (c) -> c.border_color = beautiful.border_focus)
client.connect_signal("unfocus", (c) -> c.border_color = beautiful.border_normal)
-- }}}
-- {{{ Shell autostart
-- No touchpad, please.
log ">>> Phase: autostart"

sh "xinput disable 13"

create_bash_macro = (process_name) ->
  log "> Checking if #{process_name} is running."
  "bash -c \"if pgrep #{process_name} >/dev/null; then echo 1; fi\""

autostart = (process, process_name) ->
  log "> Autostarting #{process} (#{process_name})"
  is_running = (name) ->
    -- open a bash instance to check if the process is running
    result = io.popen(create_bash_macro process_name)\read!
    return true if result == "1"
  if is_running process_name
    log "> #{process} (#{process_name}) is already running, not starting."
    return
  -- start the process
  sh process

-- Autostart apps.
log ">>> Autostarting all apps."
autostart "google-chrome-beta", "chrome"
autostart "slack", "slack"
autostart "discord-canary", "discord-canary"
autostart "telegram-desktop", "telegram"
autostart "STEAM_RUNTIME=0 steam", "steam"
-- }}}

log "*** Finished Awesome autostart. ***"
log_file\flush!
