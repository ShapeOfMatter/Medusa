module Medusa (
) where

import qualified Control.Monad.Trans.Class as MonadTrans
import Control.Monad.Trans.Either (EitherT, runEitherT)
import qualified Network.Wai as Wai
import qualified System.Eval.Utils as Eval

import qualified UnambiguiousStrings as S

data Snake a = Snake { action :: IO a }

instance ...

makeIO :: Snake Wai.Response -> IO Response
makeIO = action

servelet :: Wai.Request -> IO Wai.Response
servelet = fmap makeIO


medusa :: [Eval.Import] -> S.SText -> IO (Either S.SText Wai.Application)
medusa imports code = runEitherT $ do
    

