module Test.HTTP.Session.Store.CookieTest
  ( testSuite
  ) where

import Prelude

import Data.Either (fromRight)
import HTTP.Cookie.Types (Cookie(..))
import HTTP.Session as Session
import HTTP.Session.Store as Store
import Partial.Unsafe (unsafePartial)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (shouldEqual)

testSuite :: TestSuite
testSuite = do
  suite "HTTP.Session.Store.Cookie" do
    test "create and get round trip correctly" do
      let session = { currentUser: "drew" }
      let store = Session.cookieStore "_my_app" "724b092810ec86d7e35c9d067702b31ef90bc43a7b598626749914d6a3e033ed"
      cookie <- unsafePartial $ fromRight <$> Store.create store session
      newSession <- unsafePartial $ fromRight <$> Store.get store cookie

      newSession `shouldEqual` session

    test "create, set and get round trip correctly" do
      let session = { currentUser: "drew" }
      let session' = { currentUser: "wred" }
      let store = Session.cookieStore "_my_app" "724b092810ec86d7e35c9d067702b31ef90bc43a7b598626749914d6a3e033ed"
      cookie <- unsafePartial $ fromRight <$> Store.create store session
      cookie' <- unsafePartial $ fromRight <$> Store.set store session' cookie
      newSession <- unsafePartial $ fromRight <$> Store.get store cookie'

      newSession `shouldEqual` session'

    test "destroy returns an empty cookie" do
      let store = Session.cookieStore "_my_app" "724b092810ec86d7e35c9d067702b31ef90bc43a7b598626749914d6a3e033ed"
      cookie <- unsafePartial $ fromRight <$> Store.create store { currentUser: "drew" }
      cookie' <- unsafePartial $ fromRight <$> Store.destroy store cookie

      cookie' `shouldEqual` Empty
