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
import Effect.Aff.Class (class MonadAff)

cookieStore :: forall m a. MonadAff m => DecodeJson a => EncodeJson a => String -> String -> SessionStore m a
cookieStore = CookieStore.new

memoryStore :: forall m a. MonadAff m => DecodeJson a => EncodeJson a => String -> Effect (SessionStore m a)
memoryStore = MemoryStore.new
