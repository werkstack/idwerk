locals_without_parens = [
  defenum: 3,
  drop: 1,
  add: 2,
  add: 3,
  create: 1
]

[
  import_deps: [:phoenix, :ecto],
  inputs: ["*.{ex,exs}", "{config,lib,priv,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens
]
