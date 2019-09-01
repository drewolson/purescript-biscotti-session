module Biscotti.Session.Store.Cookie
  ( new
  ) where

import Prelude

import Biscotti.Cookie as Cookie
import Biscotti.Cookie.Types (_value)
import Biscotti.Session.Store (Destroyer, Getter, SessionStore(..), Setter, Creater)
import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson, jsonParser, stringify)
import Data.Either (Either(..))
import Data.Lens as Lens
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

new :: forall m a. MonadAff m => DecodeJson a => EncodeJson a => String -> String -> SessionStore m a
new name secret = SessionStore
  { create: create name secret
  , get: get secret
  , set: set secret
  , destroy: destroy
  }

create :: forall m a. MonadAff m => EncodeJson a => String -> String -> Creater m a
create name secret session = do
  value <- encrypt secret $ stringify $ encodeJson session

  pure $ Right $ Cookie.new name value

get :: forall m a. MonadAff m => DecodeJson a => String -> Getter m a
get secret cookie = do
  value <- decrypt secret $ Cookie.getValue cookie

  pure $ decodeJson =<< jsonParser value

set :: forall m a. MonadAff m => EncodeJson a => String -> Setter m a
set secret session cookie = do
  value <- encrypt secret $ stringify $ encodeJson session

  pure $ Right $ Lens.set _value value cookie

destroy :: forall m. MonadAff m => Destroyer m
destroy _ = pure $ Right Cookie.empty

encrypt :: forall m. MonadAff m => String -> String -> m String
encrypt secret plaintext = liftAff $ fromEffectFnAff $ _encrypt secret plaintext

decrypt :: forall m. MonadAff m => String -> String -> m String
decrypt secret ciphertext = liftAff $ fromEffectFnAff $ _decrypt secret ciphertext

foreign import _decrypt :: String -> String -> EffectFnAff String

foreign import _encrypt :: String -> String -> EffectFnAff String
