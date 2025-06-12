def url:
  if .type == "github"
  then "https://github.com/\(.owner)/\(.repo)"
  else .url
  end
; 

# input `nix flake metadata --json`

# .locks.nodes.root.inputs | keys
# | to_entries
# | select(.key | in($inputs))
# | to_entries
# | pick(.root.inputs | keys)
# .locks.nodes
# | to_entries
# | .[]
# | [.key, (.value.original | url)]

# | (.root.inputs | keys) as $inputs

.locks.nodes
| .root.inputs as $inputs
| to_entries
| .[]
| select(.key | in($inputs))
| [.key, (.value.original | url)]
| @csv
# | @csv
