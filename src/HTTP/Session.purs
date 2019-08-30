module HTTP.Session
  ( cookieStore
  , memoryStore
  , module HTTP.Session.Store
  ) where

import Data.Argonaut (class DecodeJson, class EncodeJson)
import Effect.Aff.Class (class MonadAff)
import HTTP.Session.Store (SessionStore, create, destroy, get, set)
import HTTP.Session.Store.Cookie as CookieStore
import HTTP.Session.Store.Memory as MemoryStore

cookieStore :: forall m a. MonadAff m => DecodeJson a => EncodeJson a => String -> String -> SessionStore m a
cookieStore = CookieStore.new

memoryStore :: forall m a. MonadAff m => DecodeJson a => EncodeJson a => String -> m (SessionStore m a)
memoryStore = MemoryStore.new
