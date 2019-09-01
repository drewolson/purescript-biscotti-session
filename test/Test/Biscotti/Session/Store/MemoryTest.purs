module Test.Biscotti.Session.Store.MemoryTest
  ( testSuite
  ) where

import Prelude

import Biscotti.Cookie.Types (Cookie(..))
import Biscotti.Session as Session
import Biscotti.Session.Store as Store
import Data.Either (Either(..), fromRight)
import Partial.Unsafe (unsafePartial)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (shouldEqual)

testSuite :: TestSuite
testSuite = do
  suite "Biscotti.Session.Store.Memory" do
    test "create and get round trip correctly" do
      let session = { currentUser: "drew" }
      store <- Session.memoryStore "_my_app"
      cookie <- unsafePartial $ fromRight <$> Store.create store session
      newSession <- unsafePartial $ fromRight <$> Store.get store cookie

      newSession `shouldEqual` session

    test "create, set and get round trip correctly" do
      let session = { currentUser: "drew" }
      let session' = { currentUser: "wred" }
      store <- Session.memoryStore "_my_app"
      cookie <- unsafePartial $ fromRight <$> Store.create store session
      cookie' <- unsafePartial $ fromRight <$> Store.set store session' cookie
      newSession <- unsafePartial $ fromRight <$> Store.get store cookie'

      newSession `shouldEqual` session'

    test "destroy returns an empty cookie and removes the key" do
      store <- Session.memoryStore "_my_app"
      cookie <- unsafePartial $ fromRight <$> Store.create store { currentUser: "drew" }
      cookie' <- unsafePartial $ fromRight <$> Store.destroy store cookie

      session <- Store.get store cookie

      cookie' `shouldEqual` Empty
      session `shouldEqual` Left "session not found"
