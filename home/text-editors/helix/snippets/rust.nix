[
    {
      body = ''#[cfg_attr(feature = "serde", derive(serde::Desirialize, serde::Serialize))]'';
      prefix = "dserde";
    }
    {
      body = ''println("$1{}")'';
      prefix = "p";
    }
    {
      body = ''eprintln("$1{}")'';
      prefix = "ep";
    }
    {
      body = ''#derive(Debug, $1)'';
      prefix = "der";
    }
    {
      body = ''let mut $1 = ;'';
      prefix = "lm";
    }
  ]
