module Test.Biscotti.Session.Store.CookieTest
  ( testSuite
  ) where

import Prelude
import Biscotti.Cookie.Types (Cookie(..))
import Biscotti.Session as Session
import Biscotti.Session.Store as Store
import Data.Maybe (Maybe(..))
import Test.Biscotti.Session.Support (unsafeFromRight)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (assert, shouldEqual)

testSuite :: TestSuite
testSuite = do
  suite "Biscotti.Session.Store.Cookie" do
    test "create and get round trip correctly" do
      let
        session = { currentUser: "drew" }
      let
        store = Session.cookieStore "_my_app" "724b092810ec86d7e35c9d067702b31ef90bc43a7b598626749914d6a3e033ed"
      cookie <- unsafeFromRight <$> Store.create store session
      newSession <- unsafeFromRight <$> Store.get store cookie
      newSession `shouldEqual` session
    test "create, set and get round trip correctly" do
      let
        session = { currentUser: "drew" }
      let
        session' = { currentUser: "wred" }
      let
        store = Session.cookieStore "_my_app" "724b092810ec86d7e35c9d067702b31ef90bc43a7b598626749914d6a3e033ed"
      cookie <- unsafeFromRight <$> Store.create store session
      cookie' <- unsafeFromRight <$> Store.set store session' cookie
      newSession <- unsafeFromRight <$> Store.get store cookie'
      newSession `shouldEqual` session'
    test "destroy returns an expired cookie" do
      let
        store = Session.cookieStore "_my_app" "724b092810ec86d7e35c9d067702b31ef90bc43a7b598626749914d6a3e033ed"
      cookie <- unsafeFromRight <$> Store.create store { currentUser: "drew" }
      let
        Cookie { expires } = cookie
      expires `shouldEqual` Nothing
      cookie' <- unsafeFromRight <$> Store.destroy store cookie
      let
        Cookie { expires: expires' } = cookie'
      assert "expected an expires date" $ expires' /= Nothing
