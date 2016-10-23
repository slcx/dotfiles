local awful = require("awful")
local is_modifier
is_modifier = function(modifier)
  local _list_0 = {
    "Shift",
    "Control",
    "Mod4",
    "Alt"
  }
  for _index_0 = 1, #_list_0 do
    local m = _list_0[_index_0]
    if m == modifier then
      return true
    end
  end
  return false
end
local transform
transform = function(base)
  local active_modifiers = { }
  local flat = { }
  local table_walk
  table_walk = function(tab)
    for modifier, node in pairs(tab) do
      if is_modifier(modifier) then
        table.insert(active_modifiers, modifier)
        table_walk(node)
        active_modifiers[#active_modifiers] = nil
      else
        table.insert(flat, awful.key(active_modifiers, modifier, node))
      end
    end
  end
  table_walk(base)
  return flat
end
return {
  transform = transform
}
