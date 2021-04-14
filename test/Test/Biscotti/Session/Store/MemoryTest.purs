module Test.Biscotti.Session.Store.MemoryTest
  ( testSuite
  ) where

import Prelude
import Biscotti.Cookie as Cookie
import Biscotti.Session as Session
import Biscotti.Session.Store as Store
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Test.Biscotti.Session.Support (unsafeFromRight)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (assert, shouldEqual)

testSuite :: TestSuite
testSuite = do
  suite "Biscotti.Session.Store.Memory" do
    test "create and get round trip correctly" do
      let
        session = { currentUser: "drew" }
      store <- liftEffect $ Session.memoryStore "_my_app"
      cookie <- unsafeFromRight <$> Store.create store session
      newSession <- unsafeFromRight <$> Store.get store cookie
      newSession `shouldEqual` session
    test "create, set and get round trip correctly" do
      let
        session = { currentUser: "drew" }
      let
        session' = { currentUser: "wred" }
      store <- liftEffect $ Session.memoryStore "_my_app"
      cookie <- unsafeFromRight <$> Store.create store session
      cookie' <- unsafeFromRight <$> Store.set store session' cookie
      newSession <- unsafeFromRight <$> Store.get store cookie'
      newSession `shouldEqual` session'
    test "destroy returns an expired cookie and removes the key" do
      store <- liftEffect $ Session.memoryStore "_my_app"
      cookie <- unsafeFromRight <$> Store.create store { currentUser: "drew" }
      cookie' <- unsafeFromRight <$> Store.destroy store cookie
      assert "expected an expires date" (Cookie.getExpires cookie' /= Nothing)
      session <- Store.get store cookie
      session `shouldEqual` Left "session not found"
