{
  # TODO: create a `treesiter-gdb` parser
  home.file.".gdbinit".text =
    # gdb
    ''
      set auto-load safe-path /nix/store
    '';
}
