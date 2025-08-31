{ config, ... }:
let
  chooser-file = "/tmp/yazi-chooser-file";
  yazi = "${config.programs.yazi.package}/bin/yazi";
  tree-sitter-subtree = [
    "trim_selections"
    ":tree-sitter-subtree"
  ];
in
{

  programs.helix.settings.keys = {

    insert = {
      C-z = "suspend";
      # C-space = "signature_help";
    };

    normal = {
      "C-r" = [
        ":reload"
        # ":reload-all"
        # ":config-reload"
        ":run-shell-command notify-send hx 'reloaded %{buffer_name}'"
      ];
      "A-y" = [ "yank_joined" ];
      # "A-y" = ''@"%Pyu'';
      # "A-Y" = ''@"%P<space>Yu'';

      H = [
        "jump_backward"
        "align_view_center"
      ];
      L = [
        "jump_forward"
        "align_view_center"
      ];
      # ret = [ "goto_word" ];
      "tab" = "expand_selection";
      "S-tab" = "shrink_selection";
      g.w = [
        "save_selection" # Make it possible to go back immediately with `<c-o>`
        "goto_word"
      ];
      # Idea is to always have plenty of space to actually read the popup
      # This way is a bit disruptive. Would be better with a dedicated option
      # that would take into account if we need to scroll the view to see all the
      # contents of the popup. And if so what is the minimum scroll + some configurable vertical bottom margin
      # to use.
      # TODO: suggest idea upstream in an issue.
      space.k = [
        "align_view_top" # `zt`
        "hover" # `<space>k`
      ];

      space.F = "file_picker_in_current_buffer_directory";

      # ret = [ "select_references_to_symbol_under_cursor" ];
      # y.d = [ ":yank-diagnostic" ];
      #
      # up = "select_textobject_inner";
      # down = "select_textobject_around";
      # left = "@[";
      # right = "@]";
      D = [
        "select_mode"
        "goto_line_end"
        "delete_selection"
      ];
      # H = [
      #   "goto_line_start"
      #   "goto_first_nonwhitespace"
      # ];
      Y = [
        "save_selection"
        "select_mode"
        "goto_line_end"
        "yank"
        "jump_backward"
      ]; # Similar to Y in nvim
      # w = [
      #   "move_prev_word_start"
      #   # "select_textobject_inner",
      #   # "w",
      #   "move_next_word_start"
      # ];
      # W = [
      #   "move_prev_long_word_start"
      #   # "select_textobject_inner",
      #   # "w",
      #   "move_next_long_word_start"
      # ];

      "*" = [
        "move_char_right"
        "move_prev_word_start"
        "move_next_word_end"
        "search_selection"
        "make_search_word_bounded"
        "search_next"
      ];
      "#" = [
        "move_char_right"
        "move_prev_word_start"
        "move_next_word_end"
        "search_selection"
        "make_search_word_bounded"
        "search_prev"
      ];
      # A-down = [
      #   "extend_to_line_bounds"
      #   "yank"
      #   "delete_selection"
      #   "move_line_down"
      #   "paste_before"
      # ];
      # A-j = [
      #   "extend_to_line_bounds"
      #   "yank"
      #   "delete_selection"
      #   "move_line_down"
      #   "paste_before"
      # ];
      # A-up = [
      #   "extend_to_line_bounds"
      #   "yank"
      #   "delete_selection"
      #   "move_line_up"
      #   "paste_before"
      # ];
      # A-k = [
      #   "extend_to_line_bounds"
      #   "yank"
      #   "delete_selection"
      #   "move_line_up"
      #   "paste_before"
      # ];

      space.space = "last_picker";
      # space.w = ":w";
      space.w = ":update";
      C-s = ":w";
      # C-s = [
      #   "select_all"
      #   "pipe cat -s"
      #   ":w"
      # ];
      space.q = ":buffer-close";
      space.Q = ":buffer-close-others";
      C-q = ":quit";
      space.p = "paste_clipboard_before"; # I like <space>P more as the default
      # space.n = ":set-option line-number absolute";
      # space.N = ":set-option line-number relative";
      space.t = {
        i = ":toggle-option lsp.display-inlay-hints";
        n = ":toggle-option indent-guides.render";
        p = ":toggle-option lsp.display-progress-messages";
        r = ":toggle-option rainbow-brackets";
        w = ":toggle-option soft-wrap.enable";
      };
      space.T = tree-sitter-subtree;

      # space.t.d = [":toggle-option "];
      space.l = {
        r = ":lsp-restart";
        s = ":lsp-stop";
        w = ":lsp-workspace-command";
      };

      # Replace builtin file explorer with yazi
      space.e = [
        ":sh rm -f ${chooser-file}"
        '':insert-output ${yazi} %{workspace_directory} --chooser-file=${chooser-file}''
        '':insert-output echo "\x1b[?1049h" > /dev/tty''
        '':open %sh{cat ${chooser-file}}''
        ":redraw"
      ];
      space.E = [
        ":sh rm -f ${chooser-file}"
        '':insert-output ${yazi} %{current_working_directory} --chooser-file=${chooser-file}''
        '':insert-output echo "\x1b[?1049h" > /dev/tty''
        '':open %sh{cat ${chooser-file}}''
        ":redraw"
      ];

      # space.n = [

      #   "select_register"
      #   "/"
      # ];
      backspace = ":buffer-previous";
      a = [
        "append_mode"
        "collapse_selection"
      ]; # Similar to "a" in neovim
      esc = [
        "collapse_selection"
        "keep_primary_selection"
      ]; # use esc to remove selection, AND to collapse multiple cursors into one
      X = "extend_line_above";
      C-left = "jump_view_left";
      C-right = "jump_view_right";
      C-up = "jump_view_up";
      C-down = "jump_view_down";
      C-h = "jump_view_left";
      C-l = "jump_view_right";
      C-k = "jump_view_up";
      C-j = "jump_view_down";
      # just like in a browser
      C-home = "goto_file_start";
      C-end = "goto_file_end";
      C-pageup = "goto_previous_buffer";
      C-pagedown = "goto_next_buffer";

      # space."." = "code_action";
      space.A = [ ":lsp-workspace-command" ];
      # "C-." = "code_action";
      # Select the current word
      W = "@miw";
      # Move to inside the previous parenthesis
      # H = "@F)mi(";
      # Move to inside the next parenthesis
      # L = "@f(mi(";

      g = {
        # a = "code_action"; # `ga` -> show possible code actions
        # A = ":lsp-workspace-command";
        q = ":reflow";
        Y = [
          "extend_line_below"
          "yank"
          "toggle_comments"
          "paste_after"
          "goto_line_start"
        ];
        # H = [
        #   "select_mode"
        #   "goto_line_start"
        # ];
        # L = [
        #   "select_mode"
        #   "goto_line_end"
        # ];
        S = [
          "select_mode"
          "goto_first_nonwhitespace"
        ];

        left = "jump_view_left";
        right = "jump_view_right";
        up = "jump_view_up";
        down = "jump_view_down";

        # "~" = "switch_case"
        # u = "switch_to_lowercase";
        # U = "switch_to_uppercase";
      };
      # "[" = builtins.mapAttrs (_: command: left-bracket command) {
      #   b = ":buffer-previous";
      #   d = "goto_prev_diag";
      #   D = "goto_first_diag";
      #   g = "goto_prev_change";
      #   G = "goto_first_change";
      #   f = "goto_prev_function";
      #   t = "goto_prev_class";
      #   a = "goto_prev_parameter";
      #   c = "goto_prev_comment";
      #   e = "goto_prev_entry";
      #   T = "goto_prev_test";
      #   p = "goto_prev_paragraph";
      # };
      # "]" = builtins.mapAttrs (_: command: right-bracket command) {
      #   b = ":buffer-next";
      #   d = "goto_next_diag";
      #   D = "goto_last_diag";
      #   g = "goto_next_change";
      #   G = "goto_last_change";
      #   f = "goto_next_function";
      #   t = "goto_next_class";
      #   a = "goto_next_parameter";
      #   c = "goto_next_comment";
      #   e = "goto_next_entry";
      #   T = "goto_next_test";
      #   p = "goto_next_paragraph";
      # };
    };

    select = {
      ret = [ "extend_to_word" ];
      y = [ "yank_joined" ];
      # A-x = "extend_to_line_bounds";
      X = [
        "extend_line_up"
        "extend_to_line_bounds"
      ];
      space.T = tree-sitter-subtree;
      # g = {
      #   u = "switch_to_lowercase";
      #   U = "switch_to_uppercase";
      # };
    };
  };

}
