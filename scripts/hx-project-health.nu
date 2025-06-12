#!/usr/bin/env nix-shell
#! nix-shell -i nu -p nushell fd ripgrep

#! /usr/bin/env nu

# let extensions = glob **

# let a = ^fd --type file | lines | wrap name | do { $in | get name | path parse | merge $in }

# TODO: remove the license field
let pattern_map: record<string: list<string>> = rg --type-list --no-config
| lines
| parse "{type}: {patterns}"
| update patterns { split row ", " }
| transpose --header-row --as-record
| reject license



# TODO: if not in the index, check if the file is a text or a binary file. If a binary file e.g. a png file, then filter it out

let files = ^fd --type file | lines

let a = $files | path parse | merge ($files | wrap name) 


 fd --type file
 | lines
 | do { let files = $in; $in | path parse | merge ($files | wrap name) }
 | update extension {|row| if ($row.extension | is-empty) { $row.stem } else { $row.extension } }
 | uniq-by extension

 # | get extension
 # | each { hx --health $in }

# [[filetype, language-server, debug-adapter, formatter, highlight, textobject, indent]]
