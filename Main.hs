{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)

import qualified Network.HTTP.Req as Req

import HttpEffect
import Snake
import qualified UnambiguiousStrings as US

module Main (
    main
) where

main :: IO ()
main = do
    body <- snakeToIO
        $ (fromRight "Error: was Left") . US.strictDecodeEither <$>
            performHttpRequest Req.GET (Req.https "xkcd.com") Req.NoReqBody Req.bsResponse mempty
    US.printSText body
