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
