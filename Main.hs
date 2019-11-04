{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)

app :: ConfigFile.ConfigFile -> Application
app conf request respond = do
    let key = getKey request
    case requestMethod request of
      requestGet -> do
          (oldText, oldHash) <- getfromDB key
          respond $ responseLBS
            status200
            [("Content-Type", "text/plain")]
            codeText
      requestPut -> do
          newText <- getWholeBody request
          let newHash = makeCodeHash newText
          compiled <- compile newText
          -- assume it worked
          written <- saveToDB key newText newHash
          -- assume it worked
          respond $ responseLBS
            status200
            [("Content-Type", "text/plain")]
            newHash
      requestPost -> do
          (oldText, oldHash) <- getfromDB key
          compiled <- compile oldText
          argument <- getWholeBody request
          response <- compiled argument
          respond response

main :: IO ()
main = do
    conf <- configurationParser "defaults.config"
    putStrLn $ "http://localhost:8080/"
    run 8080 $ app conf


import Data.ConfigFile (emptyCP, readfile, simpleAccess)
import Data.Monoid ((<>))
import Data.Tuple.Sequence (sequenceT)
import Hasql.Pool (release)
import Network.Wai.Middleware.RequestLogger (logStdout)
import System.Exit (die)
import Web.Scotty (ActionM, get, liftAndCatchIO, middleware, next, notFound, post, put, request, scotty)

import DBHelpers (dbPool)
import Endpoints (handleLogin, homepage, noteConsumption)

dieOnConfigError = let handleError cpError = die $ concat ["There was a config file error: ", show $ fst cpError, " ", snd cpError]
                   in either handleError return

configurationParser fileName = do
  eitherErrorParser <- readfile emptyCP fileName
  dieOnConfigError eitherErrorParser

main = do
  
  dbSettings <- let dbConf = dieOnConfigError . (simpleAccess conf "DatabaseConnectionPool")
                in  sequenceT (
                  dbConf "maxconnections",
                  dbConf "maxidleseconds",
                  dbConf "host",
                  dbConf "port",
                  dbConf "user",
                  dbConf "password",
                  dbConf "database"
                )
  pool <- dbPool dbSettings
  baseURL <- dieOnConfigError $ simpleAccess conf "SiteSettings" "baseurl"
  port <- fmap read $ dieOnConfigError $ simpleAccess conf "SiteSettings" "port" -- deliberatly unsafe.
  scotty port $ do
    middleware logStdout
    get "/" $ homepage pool baseURL
    post "/login" $ handleLogin pool
    get "/consume" $ noteConsumption pool
  release pool -- should we do this? 
