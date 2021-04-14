{ name = "biscotti-session"
, license = "MIT"
, repository = "https://github.com/drewolson/purescript-biscotti-session"
, dependencies =
  [ "aff"
  , "argonaut"
  , "bifunctors"
  , "biscotti-cookie"
  , "effect"
  , "either"
  , "maybe"
  , "ordered-collections"
  , "partial"
  , "prelude"
  , "profunctor-lenses"
  , "psci-support"
  , "refs"
  , "test-unit"
  , "uuid"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
