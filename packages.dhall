let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.3-20190827/packages.dhall sha256:93f6b11068b42eac6632d56dab659a151c231381e53a16de621ae6d0dab475ce

let overrides = {=}

let additions =
      { biscotti-cookie =
          { dependencies =
              [ "datetime"
              , "effect"
              , "either"
              , "foldable-traversable"
              , "formatters"
              , "gen"
              , "newtype"
              , "now"
              , "prelude"
              , "profunctor-lenses"
              , "psci-support"
              , "quickcheck"
              , "record"
              , "string-parsers"
              , "strings"
              , "test-unit"
              ]
          , repo =
              "https://github.com/drewolson/purescript-biscotti-cookie.git"
          , version =
              "fcd1fa9da245dfce36bcb9e790b6d6bcfa3843d0"
          }
      }

in  upstream // overrides // additions
