#!/usr/bin/env nix-shell
#! nix-shell -i nu -p hello

let data = (niri msg --json outputs | from json)

# TODO: find names from /sys/class/drm/*
let acer_monitor = {name: "DP-4"}
let laptop_screen = {name: "eDP-1"}

def extract-monitor-data [name:string] {
  let entry = $in | get $name
  {   
    name: $name
    x: $entry.logical.x
    y: $entry.logical.y
    width: $entry.logical.width
    height: $entry.logical.height
  }  
}

let laptop_screen = $data | extract-monitor-data $laptop_screen.name
let acer_monitor = $data | extract-monitor-data $acer_monitor.name

print $"setting position of ($acer_monitor.name) to x=0 y=0"
niri msg output $acer_monitor.name position set 0 0

let x = $acer_monitor.width / 2 - $laptop_screen.width / 2
let y = $acer_monitor.height

print $"setting position of ($laptop_screen.name) to x=($x) y=($y)"
niri msg output $laptop_screen.name position set $x $y


