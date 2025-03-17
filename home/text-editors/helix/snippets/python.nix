[
  {
    prefix = "ep";
    body = ''print("$1", file=sys.stderr)'';
  }
  {
    prefix = "p";
    body = ''print("$1", file=sys.stdout)'';
  }
  {
    prefix = "epf";
    body = ''print(f"{$1=}", file=sys.stderr)'';
  }
  {
    prefix = "pf";
    body = ''print(f"{$1=}", file=sys.stdout)'';
  }
  {
    prefix = "c";
    # from typing import final
    body = ''
      @final
      class $1:
          def __init__(self) -> None:
              pass
    '';
  }
  {
    prefix = "dc";
    # from typing import final
    # from dataclasses import dataclass
    body = ''
      @final
      @dataclass(frozen=True)
      class $1:
          $2
    '';
  }
]
