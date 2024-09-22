{ pkgs, ... }:

let
  PYTHONSTARTUP =
    pkgs.writers.writePython3Bin "PYTHONSTARTUP.py"
      {
        flakeIgnore = [
          "E501"
          "F401"
          "F403"
        ];
      }
      ''
        # import pkgutil
        import sys
        import os
        from pathlib import Path
        from math import *
        from time import sleep

        interpreter_name: str = sys.argv[0].split('/')[-1]
        match interpreter_name:
            case 'python':
                pass
            case 'bpython':
                pass
            case 'ipython':
                import numpy as np
            case _:
                pass

        fi = sys.float_info

        type ModuleTree = dict[str, list[str]]
        modules: ModuleTree = {}

        for m in sys.modules.values():
            name: str = m.__name__
            if name.startswith('_'):
                continue
            parts: list[str] = name.split('.')
            root: str = parts[0]
            rest: list[str] = parts[1:]
            if root not in modules:
                modules[root] = []
            for submod in rest:
                modules[root].append(submod)

        DIM: str = "ESC[22m"
        RESET: str = '\033[0m'

        for (module, submodules) in sorted(modules.items(), key=lambda pair: pair[0]):
            # print(module ,end="")
            print(module)
            if len(submodules) > 0:
                lpad: str = " " * len(module)
                for submod in submodules:
                    print(f"{lpad}.{submod}")
                    # print(f"{DIM}{module}{RESET}.{submod}")
      '';
in
{

  home.packages = with pkgs; [
    # python3
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        bpython
        tabulate
        psutil
        numpy
        python-lsp-server
      ]
    ))
  ];

  home.sessionVariables = {
    # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
    PYTHONSTARTUP = pkgs.lib.getExe PYTHONSTARTUP;
  };
}
