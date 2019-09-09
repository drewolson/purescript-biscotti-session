let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/bd72269fec59950404a380a46e293bde34b4618f/src/packages.dhall sha256:22aa195cfa65faa3231fe7e6ccd12dcd8c6215dc6598c34e6a7bd981496a3d7b

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
