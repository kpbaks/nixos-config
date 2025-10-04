{
  # programs.fish.interactiveShellInit = builtins.readFile ./keybinds.fish;

  programs.fish.interactiveShellInit =
    # fish
    ''
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

      set -l fallback 1
      if string match -q -r '^\s*$' -- $buf
        if functions -q __zoxide_zi
          # TODO: set _ZO_FZF_OPTS to bind tab to exit fzf, so you can quickly "tab+tab"
          __zoxide_zi
          set fallback 0
        else if functions -q repos
          # Commandline is empty
          repos cd
          set fallback 0
        else if set -q ZELLIJ; and command -q zellij
          # TODO: get output path and cd into it
          command zellij plugin -f -- filepicker
          set fallback 0
        end
      # else
      #     # Commandline is not empty
      #     commandline -f complete
      #     commandline -f pager-toggle-search
      end

      if test $fallback -eq 1
          commandline -f complete
          commandline -f pager-toggle-search
      end

      commandline -f repaint
    '';
}
