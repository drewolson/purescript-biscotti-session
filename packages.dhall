let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/402fbe57afb6c14bf5f5d06a93ceb7e209924abd/src/packages.dhall sha256:095e879c67df226c067f09278a76c179b00371fc086f7ffb7b80503fc10afae7

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
