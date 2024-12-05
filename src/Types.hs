{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Types 
    ( API
    , CalcResult (..)
    ) where

import Data.Aeson (ToJSON)
import Servant
import Servant.API.Generic (Generic)

type API = "add" :> Capture "x" Float :> Capture "y" Float :> Get '[JSON] CalcResult
      :<|> "mul" :> Capture "x" Float :> Capture "y" Float :> Get '[JSON] CalcResult
      :<|> "div" :> Capture "x" Float :> Capture "y" Float :> Get '[JSON] CalcResult
      :<|> "sub" :> Capture "x" Float :> Capture "y" Float :> Get '[JSON] CalcResult
      :<|> "pow" :> Capture "x" Float :> Capture "n" Float :> Get '[JSON] CalcResult
      :<|> "sqrt" :> Capture "x" Float :> Get '[JSON] CalcResult

data CalcResult = CalcResult
  { operator  :: String
  , arguments :: [Float]
  , result    :: Maybe Float
  , err       :: Maybe String
  } deriving Generic

instance ToJSON CalcResult