#!/usr/bin/env nu


def main [] {
  const url = "https://wiki.archlinux.org/title/XDG_Desktop_Portal";
  let html = (http get $url)
  let tbl = $html | htmlq .wikitable

  let headers = $tbl
  | htmlq --text th
  | lines
  | each {$in | str downcase }
  | each {
    if ($in | str ends-with "portal") {
      $in | str substring ..(-8)
    } else {
      $in
    }
  }

  let cells = $tbl
  | htmlq --text td
  | lines
  | filter { $in | is-not-empty }
  | each {
    match $in {
      "No" => $"(ansi red)✗(ansi reset)",
      "Yes" => $"(ansi green)🗸(ansi reset)",
      _ => $in
    }
  }

  let num_columns = ($headers | length)
  let chunks = $cells | chunks ($num_columns - 1)

  $chunks
  | each {|chunk|
    $headers
    | wrap header
    | merge ($chunk | wrap values)
    | transpose --header-row
  }
  | reduce {|it, acc| $acc | append $it }
  | reject toolkit # "supported environment"
  | update backend {
    let start_at = ("xdg-desktop-portal" | str length) + 1
    let name = ($in | str substring $start_at..)
    $"(ansi d)xdg-desktop-portal-(ansi reset)($name)"
    
  }
}
