{
  # programs.fish.interactiveShellInit = builtins.readFile ./keybinds.fish;

  programs.fish.interactiveShellInit = ''
    bind tab _bind_tab
  '';

  programs.fish.functions._bind_tab =
    # fish
    ''
      # If we are in paging mode, then tab should advance to the next suggestion
      # like in most text editors.
      commandline --paging-mode && down-or-search && return

      # FIXME: add a pr to detect when an autosuggestion is visible tir 10 sep 11:15:44 CEST 2024
      # commandline -f accept-autosuggestion && return

      set -l buf (commandline)
      if string match -q -r '^\s*$' -- $buf; and functions -q repos
          # Commandline is empty
          repos cd
      else
          # Commandline is not empty
          commandline -f complete
          commandline -f pager-toggle-search
      end

      commandline -f repaint
    '';
}
