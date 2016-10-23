local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local sh = awful.util.spawn_with_shell
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
do
  local _with_0 = naughty.config.defaults
  _with_0.timeout = 7
  _with_0.icon_size = 32
  _with_0.gap = 10
  _with_0.margin = 5
end
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err) end)
  if in_error then
    in_error = true
    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = err
    })
    in_error = false
  end
end
beautiful.init("/home/cheesy/.config/awesome/theme.lua")
local terminal = "/usr/local/bin/st"
local editor = "/usr/bin/vim"
local editor_cmd = tostring(terminal) .. " -e " .. tostring(editor)
local modkey = "Mod4"
local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating
}
if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end
local tags = { }
for s = 1, screen.count() do
  tags[s] = awful.tag({
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    ""
  }, s, layouts[1])
end
local menu_awesome = {
  {
    "manual",
    terminal .. " -e man awesome"
  },
  {
    "edit config",
    tostring(editor_cmd) .. " " .. tostring(awesome.conffile)
  },
  {
    "restart",
    awesome.restart
  },
  {
    "quit",
    awesome.quit
  }
}
local menu_root = awful.menu({
  items = {
    {
      "awesome",
      menu_awesome,
      beautiful.awesome_icon
    },
    {
      "open terminal",
      terminal
    }
  }
})
menubar.utils.terminal = terminal
local mytextclock = awful.widget.textclock("%I:%M:%S %p %m/%d/%Y")
local batterywidget = wibox.widget.textbox()
batterywidget:set_text("Battery")
local batterywidgettimer = timer({
  timeout = 5
})
batterywidgettimer:connect_signal("timeout", function()
  local fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))
  batterywidget:set_text(" |" .. tostring(fh:read("*l")) .. " | ")
  return fh:close()
end)
batterywidgettimer:start()
local container_box = { }
local prompt_boxes = { }
local layout_boxes = { }
local mytaglist = { }
mytaglist.buttons = awful.util.table.join(awful.button({ }, 1, awful.tag.viewonly), awful.button({
  modkey
}, 1, awful.client.movetotag), awful.button({ }, 3, awful.tag.viewtoggle), awful.button({
  modkey
}, 3, awful.client.toggletag), awful.button({ }, 5, function(t)
  return awful.tag.viewnext(awful.tag.getscreen(t))
end), awful.button({ }, 4, function(t)
  return awful.tag.viewprev(awful.tag.getscreen(t))
end))
local mytasklist = { }
mytasklist.buttons = awful.util.table.join(awful.button({ }, 1, function(c)
  if c == client.focus then
    c.minimized = true
  else
    c.minimized = false
    if not (c:isvisible()) then
      awful.tag.viewonly(c:tags()[1])
    end
    client.focus = c
    return c:raise()
  end
end), awful.button({ }, 4, function()
  awful.client.focus.byidx(1)
  if client.focus then
    return client.focus:raise()
  end
end), awful.button({ }, 5, function()
  awful.client.focus.byidx(-1)
  if client.focus then
    return client.focus:raise()
  end
end))
for s = 1, screen.count() do
  prompt_boxes[s] = awful.widget.prompt()
  layout_boxes[s] = awful.widget.layoutbox(s)
  layout_boxes[s]:buttons(awful.util.table.join(awful.button({ }, 1, function()
    return awful.layout.inc(layouts, 1)
  end), awful.button({ }, 3, function()
    return awful.layout.inc(layouts, -1)
  end), awful.button({ }, 4, function()
    return awful.layout.inc(layouts, 1)
  end), awful.button({ }, 5, function()
    return awful.layout.inc(layouts, -1)
  end)))
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
  container_box[s] = awful.wibox({
    position = "top",
    screen = s
  })
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mytaglist[s])
  left_layout:add(prompt_boxes[s])
  local right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then
    right_layout:add(wibox.widget.systray())
  end
  right_layout:add(mytextclock)
  right_layout:add(batterywidget)
  right_layout:add(layout_boxes[s])
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)
  container_box[s]:set_widget(layout)
end
root.buttons(awful.util.table.join(awful.button({ }, 3, function()
  return menu_root:toggle()
end), awful.button({ }, 4, awful.tag.viewnext), awful.button({ }, 5, awful.tag.viewprev)))
local fbd
fbd = function(d)
  awful.client.focus.bydirection(d)
  if client.focus then
    return client.focus:raise()
  end
end
local gk = {
  awful.key({
    modkey
  }, "Escape", awful.tag.history.restore),
  awful.key({ }, "XF86AudioRaiseVolume", function()
    return sh("amixer set Master 3%+")
  end),
  awful.key({ }, "XF86AudioLowerVolume", function()
    return sh("amixer set Master 3%-")
  end),
  awful.key({ }, "XF86AudioMute", function()
    return sh("amixer set Master toggle")
  end),
  awful.key({ }, "Print", function()
    return sh("maim -s --nokeyboard ~/Screenshots/$(date +%F-%T.png)")
  end),
  awful.key({
    modkey
  }, "j", function()
    return fbd("down")
  end),
  awful.key({
    modkey
  }, "k", function()
    return fbd("up")
  end),
  awful.key({
    modkey
  }, "h", function()
    return fbd("left")
  end),
  awful.key({
    modkey
  }, "l", function()
    return fbd("right")
  end),
  awful.key({
    modkey,
    "Shift"
  }, "m", function()
    return menu_root:show()
  end),
  awful.key({
    modkey,
    "Shift"
  }, "h", function()
    return awful.client.swap.byidx(1)
  end),
  awful.key({
    modkey,
    "Shift"
  }, "l", function()
    return awful.client.swap.byidx(-1)
  end),
  awful.key({
    modkey
  }, "u", awful.client.urgent.jumpto),
  awful.key({
    modkey
  }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      return client.focus:raise()
    end
  end),
  awful.key({
    modkey
  }, "Return", function()
    return awful.util.spawn(terminal)
  end),
  awful.key({
    modkey,
    "Control"
  }, "r", awesome.restart),
  awful.key({
    modkey,
    "Shift"
  }, "q", awesome.quit),
  awful.key({
    modkey,
    "Shift"
  }, "[", function()
    return awful.tag.incnmaster(-1)
  end),
  awful.key({
    modkey,
    "Shift"
  }, "]", function()
    return awful.tag.incnmaster(1)
  end),
  awful.key({
    modkey,
    "Control"
  }, "[", function()
    return awful.tag.incncol(-1)
  end),
  awful.key({
    modkey,
    "Control"
  }, "]", function()
    return awful.tag.incncol(1)
  end),
  awful.key({
    modkey
  }, "space", function()
    return awful.layout.inc(layouts, 1)
  end),
  awful.key({
    modkey,
    "Shift"
  }, "space", function()
    return awful.layout.inc(layouts, -1)
  end),
  awful.key({
    modkey,
    "Control"
  }, "n", awful.client.restore),
  awful.key({
    modkey
  }, "r", function()
    return prompt_boxes[mouse.screen]:run()
  end),
  awful.key({
    modkey
  }, "p", function()
    return menubar.show()
  end),
  awful.key({
    modkey
  }, "x", function()
    return awful.prompt.run({
      prompt = "Run Lua code: "
    }, prompt_boxes[mouse.screen].widget, awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
  end)
}
local globalkeys = awful.util.table.join(unpack(gk))
local ck = {
  awful.key({
    modkey
  }, "f", function(c)
    c.fullscreen = not c.fullscreen
  end),
  awful.key({
    modkey
  }, "w", function(c)
    return c:kill()
  end),
  awful.key({
    modkey,
    "Control"
  }, "space", awful.client.floating.toggle),
  awful.key({
    modkey,
    "Control"
  }, "Return", function(c)
    return c:swap(awful.client.getmaster())
  end),
  awful.key({
    modkey
  }, "t", function(c)
    c.ontop = not c.ontop
  end),
  awful.key({
    modkey
  }, "n", function(c)
    return c.minimized["true"]
  end),
  awful.key({
    modkey
  }, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical = not c.maximized_vertical
  end)
}
local clientkeys = awful.util.table.join(unpack(ck))
for i = 1, 9 do
  local tk = {
    awful.key({
      modkey
    }, "#" .. i + 9, function()
      local screen = mouse.screen
      local tag = awful.tag.gettags(screen)[i]
      if tag then
        return awful.tag.viewonly(tag)
      end
    end),
    awful.key({
      modkey,
      "Control"
    }, "#" .. i + 9, function()
      local screen = mouse.screen
      local tag = awful.tag.gettags(screen)[i]
      if tag then
        return awful.tag.viewtoggle(tag)
      end
    end),
    awful.key({
      modkey,
      "Shift"
    }, "#" .. i + 9, function()
      if not (client.focus) then
        return 
      end
      local tag = awful.tag.gettags(client.focus.screen)[i]
      if tag then
        return awful.client.movetotag(tag)
      end
    end),
    awful.key({
      modkey,
      "Control",
      "Shift"
    }, "#" .. i + 9, function()
      if not (client.focus) then
        return 
      end
      local tag = awful.tag.gettags(client.focus.screen)[i]
      if tag then
        return awful.client.toggletag(tag)
      end
    end)
  }
  local tagkeys = awful.util.table.join(unpack(tk))
  globalkeys = awful.util.table.join(globalkeys, tagkeys)
end
local cb = {
  awful.button({ }, 1, function(c)
    client.focus = c
    return c:raise()
  end),
  awful.button({
    modkey
  }, 1, awful.mouse.client.move),
  awful.button({
    modkey
  }, 3, awful.mouse.client.resize)
}
local clientbuttons = awful.util.table.join(unpack(cb))
root.keys(globalkeys)
awful.rules.rules = {
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
  {
    rule = {
      class = "pinentry"
    },
    properties = {
      floating = true
    }
  },
  {
    rule = {
      class = "gimp"
    },
    properties = {
      floating = true
    }
  },
  {
    rule = {
      class = "kilo2"
    },
    properties = {
      floating = true
    }
  },
  {
    rule = {
      class = "google-chrome"
    },
    properties = {
      tag = tags[1][2]
    }
  },
  {
    rule = {
      class = "discord"
    },
    properties = {
      tag = tags[1][3]
    }
  }
}
client.connect_signal("manage", function(c, startup)
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)
  if not (startup) then
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      return awful.placement.no_offscreen(c)
    end
  end
end)
client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)
return sh("xinput disable 13")
