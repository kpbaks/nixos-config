#!/usr/bin/env nu

if $env.NIRI_SOCKET? == null {
  exit 2
}

let niri_outputs = (^niri msg --json outputs | from json)

print $niri_outputs

glob /sys/class/drm/* | each {|drm| 

}
