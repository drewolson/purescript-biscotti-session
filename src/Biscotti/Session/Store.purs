module Biscotti.Session.Store
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

import Biscotti.Cookie (Cookie)
import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Either (Either)
import Effect.Aff (Aff)

type Creater a = a -> Aff (Either String Cookie)

type Getter a = Cookie -> Aff (Either String a)

type Setter a = a -> Cookie -> Aff (Either String Cookie)

type Destroyer = Cookie -> Aff (Either String Cookie)

newtype SessionStore a = SessionStore
  { create  :: Creater a
  , get     :: Getter a
  , set     :: Setter a
  , destroy :: Destroyer
  }

create :: forall a. EncodeJson a => SessionStore a -> Creater a
create (SessionStore store) = store.create

get :: forall a. DecodeJson a => SessionStore a -> Getter a
get (SessionStore store) = store.get

set :: forall a. EncodeJson a => SessionStore a -> Setter a
set (SessionStore store) = store.set

destroy :: forall a. EncodeJson a => SessionStore a -> Destroyer
destroy (SessionStore store) = store.destroy
