module Main (main) where

import Calc (app)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
    run 8081 app
