{ pkgs, ... }:
let
  script =
    pkgs.writers.writeNuBin "ros2-repos" { }
      # nu
      ''
        let url = "https://raw.githubusercontent.com/ros2/ros2/refs/heads/rolling/ros2.repos"
        let repositories = http get $url | from yaml | get repositories

        # TODO: split into owner and repo column, as not all owners are the same
        # ros-visualization/rqt_shell
        # ros2/geometry2
        $repositories | columns | wrap repository
        | merge ($repositories | values)
        | sort-by repository
      '';
in
{
  home.packages = [ script ];
}
