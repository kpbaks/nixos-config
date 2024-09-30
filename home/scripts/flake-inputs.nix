{ pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "flake-inputs" { }
      # nu
      ''
        let lock = (open flake.lock | from json)

        # FIXME: column0 is ugly, come up with something better
        let inputs = ($lock | get nodes.root.inputs | transpose | get column0)


        let now = (date now)

        $inputs
        | each {|name|
          let input = ($lock.nodes | get $name)
          let type = $input.locked.type
          match $type {
            "github" => {
              let repo = $input.locked.repo
              let owner = $input.locked.owner
              let last_modified = $input.locked.lastModified
              let time_since = ($now - ($last_modified | into duration --unit sec))
              
              # let rev = $input.locked.rev
              # let commit
              let rev = do {
                let rev = $input.locked.rev
                let commit = ($rev | str substring 0..6)
                let rest = ($rev | str substring 7..)
                $"(ansi blue)($commit)(ansi reset)(ansi d)($rest)(ansi reset)"
              }

              let url = $"(ansi d)https://github.com/(ansi reset)(ansi cyan)($owner)(ansi reset)/(ansi blue)($repo)(ansi reset)" | ansi link
              {name: $name, url: $url, rev: $rev, last-modified: $last_modified, time-since: $time_since}
            }
            _ => {}
          }
        }
      '';
in
{
  home.packages = [ script ];
}
