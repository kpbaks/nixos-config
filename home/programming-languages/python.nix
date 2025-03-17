{
  config,
  lib,
  pkgs,
  ...
}:

let
  # TODO: improve this
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

        try:
            from rich import print, inspect
        except ModuleNotFoundError:
            pass

        # interpreter_name: str = sys.argv[0].split('/')[-1]
        # match interpreter_name:
        #     case 'python':
        #         pass
        #     case 'bpython':
        #         pass
        #     # case 'ipython':
        #     #     import numpy as np
        #     case _:
        #         pass

        # fi = sys.float_info

        # type ModuleTree = dict[str, list[str]]
        # modules: ModuleTree = {}

        # for m in sys.modules.values():
        #     name: str = m.__name__
        #     if name.startswith('_'):
        #         continue
        #     parts: list[str] = name.split('.')
        #     root: str = parts[0]
        #     rest: list[str] = parts[1:]
        #     if root not in modules:
        #         modules[root] = []
        #     for submod in rest:
        #         modules[root].append(submod)

        # DIM: str = "ESC[22m"
        # RESET: str = '\033[0m'

        # for (module, submodules) in sorted(modules.items(), key=lambda pair: pair[0]):
        #     # print(module ,end="")
        #     print(module)
        #     if len(submodules) > 0:
        #         lpad: str = " " * len(module)
        #         for submod in submodules:
        #             print(f"{lpad}.{submod}")
        # print(f"{DIM}{module}{RESET}.{submod}")
      '';

  # python = (
  #   pkgs.python314.overrideAttrs
  #     (_: prev: { nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.mimalloc ]; }).withPackages
  #     (
  #       python-pkgs: with python-pkgs; [
  #         rich
  #       ]
  #     )
  # );
  # python = pkgs.python314.withPackages (p: with p; [ rich ]);
  python = pkgs.python313.withPackages (p: with p; [ rich ]);

in

{

  home.packages = [ python ];

  home.sessionVariables = {
    # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
    PYTHONSTARTUP = pkgs.lib.getExe PYTHONSTARTUP;
    PYTHON_COLORS = "1"; # use colors in the new python repl introduced in v3.13 (default)
    PYTHONUTF8 = "1"; # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUTF8
    PYTHON_HISTORY = "${config.xdg.cacheHome}.python/python_history";
    # PYTHONMALLOC = "mimalloc";
  };

  programs.matplotlib.enable = false;
  programs.matplotlib.config = { };

  xdg.configFile."mypy/config".text = lib.generators.toINI { } {
    mypy = {
      warn_return_any = true;
      warn_unused_configs = true;
    };
  };
  # TODO: test and improve
  # use `inspect` module for something cool https://docs.python.org/3/library/inspect.html
  # https://kylekizirian.github.io/ned-batchelders-updated-pdbrc.html
  home.file.".pdbrc".text =
    # python
    ''
      	      import pdb

      	      try:
      	      	from rich import print
      	      except ModuleNotFoundError:
      	      	pass

      	      try:
      	      	from IPython import print
      	      except ModuleNotFoundError:
      	      	pass
      	      alias p_ for k in sorted(%1.keys()): print(f"%2{k.ljust(max(len(s) for s in %1.keys()))} = {%1[k]}")

      		# Print the member variables of a thing.
              alias pi p_ %1.__dict__ %1.

              # Print the member variables of self.
              alias ps pi self

              # Print the locals.
              alias pl p_ locals() local:
                                                    	
            	# Next and list, and step and list.
            	alias nl n;;l
            	alias sl s;;l

            	alias pid import os; os.getpid()
    '';
}
