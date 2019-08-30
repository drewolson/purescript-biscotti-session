module HTTP.Session
  ( cookieStore
  , module HTTP.Session.Store
  ) where

import Data.Argonaut (class DecodeJson, class EncodeJson)
import Effect.Aff.Class (class MonadAff)
import HTTP.Session.Store (Creater, SessionStore(..), Getter)
import HTTP.Session.Store.Cookie as CookieStore

cookieStore :: forall m a. MonadAff m => DecodeJson a => EncodeJson a => String -> String -> SessionStore m a
cookieStore = CookieStore.new
