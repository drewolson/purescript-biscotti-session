-- | The `Memory` session store uses an in-memory map to store sessions. This is
-- | primarily for development purposes as it will not persist sessions across
-- | multiple application servers. You'll need to install two npm packages to
-- | generate UUIDs:
-- |
-- | ```text
-- | npm install uuid uuid-validate
-- | ```
-- |
-- | You create a `Memory` store by calling `Biscotti.Session.memoryStore` with a
-- | name for your session cookie. Note that this returns a `Effect SessionStore`
-- | because it requires initializing a `Ref`.
-- |
-- | ```purescript
-- | import Biscotti.Session as Session
-- |
-- | launchAff_ do
-- |   store <- liftEffect $ Session.memoryStore "_my_app"
-- | ```
module Biscotti.Session.Store.Memory
  ( new
  ) where

import Prelude

import Biscotti.Cookie as Cookie
import Biscotti.Cookie.Types (Cookie)
import Biscotti.Session.Store (Destroyer, Getter, SessionStore(..), Setter, Creater)
import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson, jsonParser, stringify)
import Data.Either (Either(..), note)
import Data.Map (Map)
import Data.Map as Map
import Data.UUID (UUID)
import Data.UUID as UUID
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Ref (Ref)
import Effect.Ref as Ref

type Store = Ref (Map UUID String)

new :: forall a. DecodeJson a => EncodeJson a => String -> Effect (SessionStore a)
new name = do
  store <- Ref.new $ Map.empty

  pure $ SessionStore
    { create: create store name
    , get: get store
    , set: set store
    , destroy: destroy store
    }

create :: forall a. EncodeJson a => Store -> String -> Creater a
create store name session = do
  key <- liftEffect $ UUID.genUUID
  let value = stringify $ encodeJson session
  liftEffect $ Ref.modify_ (Map.insert key value) store

  pure $ Right $ Cookie.new name (UUID.toString key)

get :: forall a. DecodeJson a => Store -> Getter a
get store cookie = do
  map <- liftEffect $ Ref.read store

  pure do
    key <- getKey cookie
    val <- note "session not found" $ Map.lookup key map
    json <- jsonParser val

    decodeJson json

set :: forall a. EncodeJson a => Store -> Setter a
set store session cookie = do
  case getKey cookie of
    Left e ->
      pure $ Left e

    Right key -> do
      let value = stringify $ encodeJson $ session
      liftEffect $ Ref.modify_ (Map.insert key value) store
      pure $ Right cookie

destroy :: Store -> Destroyer
destroy store cookie = do
  case getKey cookie of
    Left e ->
      pure $ Left e

    Right key -> do
      liftEffect $ Ref.modify_ (Map.delete key) store
      liftEffect $ Cookie.expire cookie

getKey :: Cookie -> Either String UUID
getKey =
  note "invalid UUID" <<< UUID.parseUUID <<< Cookie.getValue
