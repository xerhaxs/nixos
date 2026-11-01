if not (hl.plugin and hl.plugin.hyprgrass) then
  return
end

hl.config({
  plugin = {
    hyprgrass = {
      sensitivity = 4.0,
      long_press_delay = 400,
      edge_margin = 15,
    },
  },
})

hl.plugin.hyprgrass.gesture({
  pattern = { kind = "swipe", fingers = 3, direction = "horizontal" },
  action = "workspace",
})

hl.plugin.hyprgrass.bind({
  pattern = { kind = "edge", origin = "down", direction = "up" },
  action = hl.dsp.exec_cmd("pkill -RTMIN wvkbd-mobintl"),
})

hl.plugin.hyprgrass.bind({
  pattern = { kind = "edge", origin = "left", direction = "right" },
  action = hl.dsp.exec_cmd("rofi -show drun -show-icons"),
})

hl.plugin.hyprgrass.bind({
  pattern = { kind = "edge", origin = "right", direction = "left" },
  action = hl.dsp.exec_cmd("swaync-client --toggle-panel --skip-wait"),
})

hl.plugin.hyprgrass.bind({
  pattern = { kind = "swipe", fingers = 3, direction = "down" },
  action = hl.dsp.window.close(),
})

hl.plugin.hyprgrass.bind({
  pattern = { kind = "swipe", fingers = 4, direction = "up" },
  action = function()
    if hl.plugin.hyprtasking then
      hl.plugin.hyprtasking.toggle("all")
    end
  end,
})

hl.plugin.hyprgrass.bind({
  pattern = { kind = "longpress", fingers = 2 },
  action = hl.dsp.window.drag(),
  mouse = true,
})
