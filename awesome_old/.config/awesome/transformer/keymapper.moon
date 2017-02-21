awful = require "awful"

is_modifier = (modifier) ->
  for m in *{"Shift", "Control", "Mod4", "Alt"}
    return true if m == modifier
  false

transform = (base) ->
  active_modifiers = {}
  flat = {}

  table_walk = (tab) ->
    for modifier, node in pairs tab
      if is_modifier modifier
        table.insert active_modifiers, modifier
        table_walk node
        active_modifiers[#active_modifiers] = nil
      else
        table.insert flat, awful.key(active_modifiers, modifier, node)

  -- walk the base table.
  table_walk base
  flat

{ :transform }
