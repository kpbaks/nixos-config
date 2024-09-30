# https://github.com/laixintao/tokei-pie/blob/main/tokei_pie/main.py
{ pkgs, ... }:
let
  script =
    pkgs.writers.writePython3Bin "tokei-pie"
      {
        libraries = with pkgs.python3Packages; [ plotly ];
        flakeIgnore = [
          "E501"
          "F401"
          "F403"
        ];
      }
      # python
      ''
        import os
        import time
        import json
        import argparse
        import sys
        import plotly.graph_objects as go
        import subprocess
        from dataclasses import dataclass

        @dataclass
        class Sector:
            id: str
            label: str

            parent_id: str
            lang_type: str

            code: int = 0
            blanks: int = 0
            comments: int = 0
            inaccurate: bool = False


        if os.isatty(sys.stdin.fileno()):
            input = subprocess.run(["${pkgs.tokei}/bin/tokei", "--output", "json"])
        else:
            try:
              input = json.load(sys.stdin)
            except:
              print(
                f"Stdin is not json, please pass tokei's json output to tokei-pie, like this: tokei -o json | {sys.argv[0]}",
                file=sys.stderr,
              )
              sys.exit(128)

        if __name__ == "__main__":
          main()
      '';
in
{
  home.packages = [ script ];
}
