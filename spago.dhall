{ name =
    "session"
, dependencies =
    [ "aff"
    , "argonaut"
    , "console"
    , "cookie-parser"
    , "effect"
    , "newtype"
    , "prelude"
    , "profunctor-lenses"
    , "psci-support"
    , "test-unit"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
