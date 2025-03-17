let
  fish-events = map (name: "fish_" + name) [
    "cancel"
    "command_not_found"
    "exit"
    "posterror"
    "postexec"
    "preexec"
    "prompt"
  ];
  fish-events-snippets = map (fish_event: {
    prefix = fish_event;
    body = ''function $1 --on-event ${fish_event};;end'';
  }) fish-events;
  query-snippets =
    map
      (
        type:
        let
          prefix = (builtins.substring 0 1 type) + "q";
        in
        {
          inherit prefix;
          body = type + " --query ";
        }
      )
      [
        "builtin"
        "functions"
        "command"
        "set"
        "abbr"
      ];
  equality-snippets =
    map
      (op: {
        prefix = op;
        body = "test $1 -${op} ";
      })
      [
        "eq"
        "ne"
        "gt"
        "lt"
        "ge"
        "le"
      ];
in

fish-events-snippets
++ query-snippets
++ equality-snippets
++ (map
  (
    pair:
    let
      prefix = builtins.elemAt pair 0;
      body = builtins.elemAt pair 1;
    in
    {
      inherit prefix body;
    }
  )
  [
    [
      "wrl"
      "while read line; $1; end"
    ]
    [
      "len"
      "string length "
    ]
    [
      "sub"
      "string sub --start=$1 "
    ]
    [
      "repeat"
      "string repeat --count=$1 "
    ]
    [
      "m"
      "string match '$1'"
    ]
    [
      "mr"
      "string match --regex '$1'"
    ]
    [
      "mrg"
      "string match --regex --groups-only '$1'"
    ]
    [
      "mrq"
      "string match --regex --quiet '$1'"
    ]
  ]
)
