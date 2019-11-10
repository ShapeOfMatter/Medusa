{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE LambdaCase, BlockArguments #-}
{-# LANGUAGE GADTs, FlexibleContexts, TypeOperators, DataKinds, PolyKinds, ScopedTypeVariables #-}

module HttpEffect (
    HttpEffect (PerformHttpRequest)
   ,performHttpRequest
   ,httpToIO
) where

import Polysemy
import Polysemy.Input
import Polysemy.Output

import Data.Proxy
import Network.HTTP.Req

data HttpEffect m a where
  PerformHttpRequest ::
    (MonadHttp m, HttpMethod method, HttpBody body, HttpResponse response, HttpBodyAllowed (AllowsBody method) (ProvidesBody body))
      => method             -- HTTP method
      -> Url scheme         -- Url—location of resource
      -> body               -- Body of the request
      -> Proxy response     -- A hint how to interpret response
      -> Option scheme      -- Collection of optional parameters
      -> HttpEffect m response

makeSem ''HttpEffect

httpToIO :: Member (Embed IO) r => Sem (HttpEffect ': r) a -> Sem r a
httpToIO =
    interpret 
        $ \(PerformHttpRequest method url body responseType options)
            -> embed 
                $ runReq defaultHttpConfig
                    $ req method url body responseType options

