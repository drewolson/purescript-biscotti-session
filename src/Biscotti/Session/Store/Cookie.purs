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
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Class (liftEffect)

new :: forall a. DecodeJson a => EncodeJson a => String -> String -> SessionStore a
new name secret = SessionStore
  { create: create name secret
  , get: get secret
  , set: set secret
  , destroy: destroy
  }

create :: forall a. EncodeJson a => String -> String -> Creater a
create name secret session = do
  value <- encrypt secret $ stringify $ encodeJson session

  pure $ Right $ Cookie.new name value

get :: forall a. DecodeJson a => String -> Getter a
get secret cookie = do
  value <- decrypt secret $ Cookie.getValue cookie

  pure $ decodeJson =<< jsonParser value

set :: forall a. EncodeJson a => String -> Setter a
set secret session cookie = do
  value <- encrypt secret $ stringify $ encodeJson session

  pure $ Right $ Lens.set _value value cookie

destroy :: Destroyer
destroy = liftEffect <<< Cookie.expired

encrypt :: String -> String -> Aff String
encrypt secret plaintext = fromEffectFnAff $ _encrypt secret plaintext

decrypt :: String -> String -> Aff String
decrypt secret ciphertext = fromEffectFnAff $ _decrypt secret ciphertext

foreign import _decrypt :: String -> String -> EffectFnAff String

foreign import _encrypt :: String -> String -> EffectFnAff String
