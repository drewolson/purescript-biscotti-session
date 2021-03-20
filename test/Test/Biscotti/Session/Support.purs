module Test.Biscotti.Session.Support
  ( unsafeFromRight
  ) where

import Data.Either (Either, fromRight')
import Partial.Unsafe (unsafeCrashWith)

unsafeFromRight :: forall e a. Either e a -> a
unsafeFromRight = fromRight' (\_ -> unsafeCrashWith "Unexpected Left")
