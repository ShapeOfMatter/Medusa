{-# LANGUAGE OverloadedStrings #-}

module Main (
    main
) where

import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)

import Data.Either (fromRight)
import qualified Network.HTTP.Req as Req

import HttpEffect
import Snake
import qualified UnambiguiousStrings as US

main :: IO ()
main = do
    body <- snakeToIO . Snake
        $ (fromRight "Error: was Left") . US.strictDecodeEither . Req.responseBody <$>
            performHttpRequest Req.GET (Req.https "xkcd.com") Req.NoReqBody Req.bsResponse mempty
    US.printSText body
