module HTTP.Session.Store
  ( Creater
  , Destroyer
  , Getter
  , SessionStore(..)
  , Setter
  , create
  , destroy
  , get
  , set
  ) where

import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Either (Either)
import Effect.Aff.Class (class MonadAff)
import HTTP.Cookie (Cookie)

type Creater m a = a -> m (Either String Cookie)

type Getter m a = Cookie -> m (Either String a)

type Setter m a = a -> Cookie -> m (Either String Cookie)

type Destroyer m = Cookie -> m (Either String Cookie)

newtype SessionStore m a = SessionStore
  { create  :: Creater m a
  , get     :: Getter m a
  , set     :: Setter m a
  , destroy :: Destroyer m
  }

create :: forall m a. MonadAff m => EncodeJson a => SessionStore m a -> Creater m a
create (SessionStore store) = store.create

get :: forall m a. MonadAff m => DecodeJson a => SessionStore m a -> Getter m a
get (SessionStore store) = store.get

set :: forall m a. MonadAff m => EncodeJson a => SessionStore m a -> Setter m a
set (SessionStore store) = store.set

destroy :: forall m a. MonadAff m => EncodeJson a => SessionStore m a -> Destroyer m
destroy (SessionStore store) = store.destroy
