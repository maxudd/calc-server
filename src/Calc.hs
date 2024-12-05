{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
-- {-# LANGUAGE TypeOperators #-}


module Calc (app) where

import Types ( CalcResult(CalcResult), API )
import Servant



handleErrors :: String -> [Float] -> Float -> CalcResult
handleErrors op args res | isNaN res                     = CalcResult op args Nothing (Just "Negative argument of sqrt")
                         | isInfinite res && op == "div" = CalcResult op args Nothing $ Just "Division by zero"
                         | isInfinite res && op == "pow" = CalcResult op args Nothing $ Just "Raising zero to negative power"
                         | otherwise                     = CalcResult op args (Just res) Nothing

server :: Server API
server = add_op
     :<|> mul_op
     :<|> div_op
     :<|> sub_op
     :<|> pow_op
     :<|> sqrt_op

  where add_op :: Float -> Float -> Handler CalcResult
        add_op x y = return (handleErrors "add" [x, y] (x + y))

        mul_op :: Float -> Float -> Handler CalcResult
        mul_op x y = return (handleErrors "mul" [x, y] (x * y))

        div_op :: Float -> Float -> Handler CalcResult
        div_op x y = return (handleErrors "div" [x, y] (x / y))

        sub_op :: Float -> Float -> Handler CalcResult
        sub_op x y = return (handleErrors "sub" [x, y] (x - y))

        pow_op :: Float -> Float -> Handler CalcResult
        pow_op x y = return (handleErrors "pow" [x, y] (x ** y))

        sqrt_op :: Float -> Handler CalcResult
        sqrt_op x = return (handleErrors "sqrt" [x] (sqrt x))



api :: Proxy API
api = Proxy

app :: Application
app = serve api server
