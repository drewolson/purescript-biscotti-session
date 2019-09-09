-- | `Session` provides 4 basic functions: `create`, `get`, `set` and `destroy`.
-- |
-- | * `create` takes a `SessionStore` and your session data and returns a
-- |   [Cookie](https://github.com/drewolson/purescript-biscotti-cookie) representing
-- |   your new session.
-- | * `get` takes a `SessionStore` and a `Cookie` and returns your session data, if
-- |   available.
-- | * `set` takes a `SessionStore`, your session data and your current session
-- |   `Cookie`. It returns a new session `Cookie`.
-- | * `destroy` takes a `SessionStore` and your session `Cookie` and returns a new,
-- |    empty session `Cookie`.
module Biscotti.Session
  ( cookieStore
  , memoryStore
  , module Biscotti.Session.Store
  ) where

import Biscotti.Session.Store (SessionStore, create, destroy, get, set)
import Biscotti.Session.Store.Cookie as CookieStore
import Biscotti.Session.Store.Memory as MemoryStore
import Data.Argonaut (class DecodeJson, class EncodeJson)
import Effect (Effect)

cookieStore :: forall a. DecodeJson a => EncodeJson a => String -> String -> SessionStore a
cookieStore = CookieStore.new

memoryStore :: forall a. DecodeJson a => EncodeJson a => String -> Effect (SessionStore a)
memoryStore = MemoryStore.new
