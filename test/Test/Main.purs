module Test.Main where

import Prelude

import Effect (Effect)
import Test.HTTP.Session.Store.CookieTest as CookieTest
import Test.HTTP.Session.Store.MemoryTest as MemoryTest
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  CookieTest.testSuite
  MemoryTest.testSuite
