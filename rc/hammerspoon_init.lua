BASE_MOUSE_SPEED = 6.0
local wf = hs.window.filter
local filter = wf.new(true)

function is_osu_window(title)
  return title:match('^osu!cuttingedge b%d%d%d%d%d%d%d%d') ~= nil
end

filter:subscribe(wf.windowFocused, function(window)
  if is_osu_window(window:title()) then
    hs.mouse.trackingSpeed(-1)
  else
    hs.mouse.trackingSpeed(BASE_MOUSE_SPEED)
  end
  print('window title:', window:title())
  print('tracking speed:', hs.mouse.trackingSpeed())
end)
