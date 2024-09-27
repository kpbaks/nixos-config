from typing import Any, Dict

from kitty.boss import Boss
from kitty.window import Window
import subprocess
from dataclasses import dataclass
from enum import Enum

class Urgency(Enum):
  Low = 1
  Normal = 2
  Critical = 3

def notify_send(title: str, msg: str, urgency: Urgency = Urgency.Normal, transient: bool = False) -> None:
  # subprocess.run("${pkgs.libnotify}/bin/notify-send")
  subprocess.run("notify-send")

def on_resize(boss: Boss, window: Window, data: Dict[str, Any]) -> None:
  # Here data will contain old_geometry and new_geometry
  # Note that resize is also called the first time a window is created
  # which can be detected as old_geometry will have all zero values, in
  # particular, old_geometry.xnum and old_geometry.ynum will be zero.
  # boss.call_remote_control(window, ('send-text', f'--match=id:{window.id}', 'hello world'))
  pass

def on_focus_change(boss: Boss, window: Window, data: Dict[str, Any])-> None:
  # Here data will contain focused
  pass

def on_close(boss: Boss, window: Window, data: Dict[str, Any])-> None:
  # called when window is closed, typically when the program running in
  # it exits
  pass

def on_set_user_var(boss: Boss, window: Window, data: Dict[str, Any]) -> None:
  # called when a "user variable" is set or deleted on a window. Here
  # data will contain key and value
  pass

def on_title_change(boss: Boss, window: Window, data: Dict[str, Any]) -> None:
  # called when the window title is changed on a window. Here
  # data will contain title and from_child. from_child will be True
  # when a title change was requested via escape code from the program
  # running in the terminal
  pass

def on_cmd_startstop(boss: Boss, window: Window, data: Dict[str, Any]) -> None:
  # called when the shell starts/stops executing a command. Here
  # data will contain is_start, cmdline and time.
  pass
