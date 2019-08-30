module HTTP.Session.Store.Memory
  ( new
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson, jsonParser, stringify)
import Data.Either (Either(..), note)
import Data.Map (Map)
import Data.Map as Map
import Data.UUID (UUID)
import Data.UUID as UUID
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import HTTP.Cookie as Cookie
import HTTP.Cookie.Types (Cookie(..))
import HTTP.Session.Store (Destroyer, Getter, SessionStore(..), Setter, Creater)

type Store = Ref (Map UUID String)

new :: forall m a. MonadAff m => DecodeJson a => EncodeJson a => String -> m (SessionStore m a)
new name = do
  store <- liftEffect $ Ref.new $ Map.empty

  pure $ SessionStore
    { create: create store name
    , get: get store
    , set: set store
    , destroy: destroy store
    }

create :: forall m a. MonadAff m => EncodeJson a => Store -> String -> Creater m a
create store name session = do
  key <- liftEffect $ UUID.genUUID
  let value = stringify $ encodeJson session
  liftEffect $ Ref.modify_ (Map.insert key value) store

  pure $ Right $ Cookie.new name (UUID.toString key)

get :: forall m a. MonadAff m => DecodeJson a => Store -> Getter m a
get store cookie = do
  map <- liftEffect $ Ref.read store

  pure $ do
    key <- getKey cookie
    val <- note "session not found" $ Map.lookup key map
    json <- jsonParser val

    decodeJson json

set :: forall m a. MonadAff m => EncodeJson a => Store -> Setter m a
set store session cookie = do
  case getKey cookie of
    Left e ->
      pure $ Left e
    Right key -> do
      let value = stringify $ encodeJson $ session
      liftEffect $ Ref.modify_ (Map.insert key value) store
      pure $ Right cookie

destroy :: forall m. MonadAff m => Store -> Destroyer m
destroy store cookie = do
  case getKey cookie of
    Left e ->
      pure $ Left e
    Right key -> do
      liftEffect $ Ref.modify_ (Map.delete key) store
      pure $ Right Empty

getKey :: Cookie -> Either String UUID
getKey =
  note "invalid UUID" <<< UUID.parseUUID <<< Cookie.getValue
