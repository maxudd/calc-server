{-# LANGUAGE OverloadedStrings #-}
-- {-# LANGUAGE QuasiQuotes       #-}
module Main (main) where

import  Calc  (app)
import  Test.Hspec
import  Test.Hspec.Wai


main :: IO ()
main = hspec spec

spec :: Spec
spec = with (return app) $ do
    describe "GET /add" $ do
        it "responds with 200" $ do
            get "/add/6/100" `shouldRespondWith` 200
        it "responds with correct answer" $ do
            get "/add/6/100" `shouldRespondWith` "{\"arguments\":[6,100],\"err\":null,\"operator\":\"add\",\"result\":106}"
        it "responds with 400 if argument is not a number" $ do
            get "/add/6/*" `shouldRespondWith` 400
    describe "GET /mul" $ do
        it "responds with 200" $ do
            get "/mul/5/44" `shouldRespondWith` 200
        it "responds with correct answer" $ do
            get "/mul/5/44" `shouldRespondWith` "{\"arguments\":[5,44],\"err\":null,\"operator\":\"mul\",\"result\":220}"
        it "responds with 400 if argument is not a number" $ do
            get "/mul/6/*" `shouldRespondWith` 400
    describe "GET /div" $ do
        it "responds with 200" $ do
            get "/div/100/4" `shouldRespondWith` 200
        it "responds with correct answer" $ do
            get "/div/100/4" `shouldRespondWith` "{\"arguments\":[100,4],\"err\":null,\"operator\":\"div\",\"result\":25}"
        it "responds with error if number is divided by zero" $ do
            get "/div/100/0" `shouldRespondWith` "{\"arguments\":[100,0],\"err\":\"Division by zero\",\"operator\":\"div\",\"result\":null}"
        it "responds with 400 if argument is not a number" $ do
            get "/div/6/*" `shouldRespondWith` 400
    describe "GET /sub" $ do
        it "responds with 200" $ do
            get "/sub/100/500" `shouldRespondWith` 200
        it "responds with correct answer" $ do
            get "/sub/100/500" `shouldRespondWith` "{\"arguments\":[100,500],\"err\":null,\"operator\":\"sub\",\"result\":-400}"
        it "responds with 400 if argument is not a number" $ do
            get "/sub/6/*" `shouldRespondWith` 400
    describe "GET /pow" $ do
        it "responds with 200" $ do
            get "/pow/2/10" `shouldRespondWith` 200
        it "responds with correct answer" $ do
            get "/pow/2/10" `shouldRespondWith` "{\"arguments\":[2,10],\"err\":null,\"operator\":\"pow\",\"result\":1024}"
        it "responds with error if trying to raise zero to negative power" $ do
            get "/pow/0/-10" `shouldRespondWith` "{\"arguments\":[0,-10],\"err\":\"Raising zero to negative power\",\"operator\":\"pow\",\"result\":null}"
        it "responds with 400 if argument is not a number" $ do
            get "/pow/6/*" `shouldRespondWith` 400
    describe "GET /sqrt" $ do
        it "responds with 200" $ do
            get "/sqrt/5" `shouldRespondWith` 200
        it "responds with correct answer" $ do
            get "/sqrt/5" `shouldRespondWith` "{\"arguments\":[5],\"err\":null,\"operator\":\"sqrt\",\"result\":2.236068}"
        it "responds with error if trying to get square root of negative number" $ do
            get "/sqrt/-5" `shouldRespondWith` "{\"arguments\":[-5],\"err\":\"Negative argument of sqrt\",\"operator\":\"sqrt\",\"result\":null}"
    describe "GET /sin/5" $ do
        it "responds with 404" $ do
            get "/sin/5" `shouldRespondWith` 404

