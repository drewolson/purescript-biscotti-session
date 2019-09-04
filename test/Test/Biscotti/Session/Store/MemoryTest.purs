module Test.Biscotti.Session.Store.MemoryTest
  ( testSuite
  ) where

import Prelude

import Biscotti.Cookie.Types (Cookie(..))
import Biscotti.Session as Session
import Biscotti.Session.Store as Store
import Data.Either (Either(..), fromRight)
import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Partial.Unsafe (unsafePartial)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (assert, shouldEqual)

testSuite :: TestSuite
testSuite = do
  suite "Biscotti.Session.Store.Memory" do
    test "create and get round trip correctly" do
      let session = { currentUser: "drew" }
      store <- liftEffect $ Session.memoryStore "_my_app"
      cookie <- unsafePartial $ fromRight <$> Store.create store session
      newSession <- unsafePartial $ fromRight <$> Store.get store cookie

      newSession `shouldEqual` session

    test "create, set and get round trip correctly" do
      let session = { currentUser: "drew" }
      let session' = { currentUser: "wred" }
      store <- liftEffect $ Session.memoryStore "_my_app"
      cookie <- unsafePartial $ fromRight <$> Store.create store session
      cookie' <- unsafePartial $ fromRight <$> Store.set store session' cookie
      newSession <- unsafePartial $ fromRight <$> Store.get store cookie'

      newSession `shouldEqual` session'

    test "destroy returns an expired cookie and removes the key" do
      store <- liftEffect $ Session.memoryStore "_my_app"
      cookie <- unsafePartial $ fromRight <$> Store.create store { currentUser: "drew" }

      Cookie { expires } <- unsafePartial $ fromRight <$> Store.destroy store cookie
      assert "expected an expires date" (expires /= Nothing)

      session <- Store.get store cookie
      session `shouldEqual` Left "session not found"
