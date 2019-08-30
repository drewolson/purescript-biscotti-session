{ name =
    "session"
, dependencies =
    [ "aff"
    , "argonaut"
    , "cookie-parser"
    , "effect"
    , "newtype"
    , "ordered-collections"
    , "prelude"
    , "profunctor-lenses"
    , "psci-support"
    , "refs"
    , "test-unit"
    , "uuid"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
