from libqtile import bar, layout, widget
from libqtile.config import Key, Screen
from libqtile.lazy import lazy
import os

mod = "mod4"
terminal = "ghostty"

keys = [
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "Escape", lazy.shutdown()),
]

layouts = [
    layout.MonadTall(border_width=2, margin=8),
    layout.Max(),
]

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.WindowName(),
                widget.Clock(format="%Y-%m-%d %H:%M"),
            ],
            24,
        ),
    ),
]

mouse = []
dgroups_key_binder = None
dgroups_app_rules = []

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"

wmname = "LG3D"
