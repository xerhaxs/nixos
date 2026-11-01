local ok, colors = pcall(require, "themes.catppuccin")
if not ok then
  colors = {
    accent = "rgb(cba6f7)",
    lavender = "rgb(b4befe)",
    surface1 = "rgb(45475a)",
  }
end

local terminal = "kitty"
local fileManager = "dolphin"
local launcher = "rofi -show drun -show-icons"
local mainMod = "SUPER"

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("keepassxc")
end)

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 12,
    border_size = 2,
    col = {
      active_border = { colors = { colors.accent, colors.lavender }, angle = 45 },
      inactive_border = colors.surface1,
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 12,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 0.95,
    shadow = {
      enabled = true,
      range = 12,
      render_power = 3,
      color = 0xee11111b,
    },
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
      vibrancy = 0.1696,
      popups = true,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    focus_on_activate = true,
    vrr = 2,
  },

  input = {
    kb_layout = "de",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
    },
  },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p clipboard | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker --autocopy"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client --toggle-panel --skip-wait"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("systemctl --user start wallpaper-random.service"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("wlogout --protocol layer-shell"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind("XF86Calculator", hl.dsp.exec_cmd("qalculate-gtk"))

-- screenshots
hl.bind("Print", hl.dsp.exec_cmd("flameshot gui"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("flameshot screen --clipboard"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("flameshot full --clipboard"))

-- scratchpads (pyprland)
hl.bind(mainMod .. " + GRAVE", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pypr toggle volume"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr zoom"))

-- windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + K", hl.dsp.window.pin())

for _, dir in ipairs({ "left", "right", "up", "down" }) do
  hl.bind(mainMod .. " + " .. dir, hl.dsp.focus({ direction = dir }))
  hl.bind(mainMod .. " + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- media and hardware keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- plugins
if hl.plugin and hl.plugin.hyprtasking then
  hl.bind(mainMod .. " + TAB", function() hl.plugin.hyprtasking.toggle("cursor") end)
  hl.bind("escape", function()
    if hl.plugin.hyprtasking.is_active() then
      hl.plugin.hyprtasking.toggle("all")
    end
  end, { non_consuming = true })
  hl.config({
    plugin = {
      hyprtasking = {
        layout = "grid",
        gap_size = 12,
      },
    },
  })
end

if hl.plugin and hl.plugin.dynamic_cursors then
  hl.config({
    plugin = {
      dynamic_cursors = {
        enabled = true,
        mode = "tilt",
        shake = {
          enabled = true,
        },
      },
    },
  })
end

-- window and layer rules
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ name = "idle-inhibit-fullscreen", match = { class = ".*" }, idle_inhibit = "fullscreen" })

for _, class in ipairs({
  "^(org.pulseaudio.pavucontrol)$",
  "^(qalculate-gtk)$",
  "^(nm-connection-editor)$",
  "^(org.keepassxc.KeePassXC)$",
  "^(waypaper)$",
  "^(xdg-desktop-portal-gtk)$",
  "^(org.kde.polkit-kde-authentication-agent-1)$",
  "^(hyprland-share-picker)$",
}) do
  hl.window_rule({ name = "float-" .. class, match = { class = class }, float = true, center = true })
end

hl.window_rule({ name = "pip", match = { title = "^(Picture-in-Picture|Bild-im-Bild)$" }, float = true, pin = true, keep_aspect_ratio = true })

hl.window_rule({
  name = "fix-xwayland-drags",
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

hl.layer_rule({
  name = "blur-shell",
  match = { namespace = "^(waybar|rofi|swaync-control-center|swaync-notification-window|logout_dialog)$" },
  blur = true,
  ignore_alpha = 0.3,
})
