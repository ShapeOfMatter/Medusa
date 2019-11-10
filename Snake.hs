{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE LambdaCase, BlockArguments #-}
{-# LANGUAGE GADTs, FlexibleContexts, TypeOperators, DataKinds, PolyKinds, ScopedTypeVariables #-}

module Snake (
    Snake (Snake)
   ,snakeToIO
) where

import Polysemy
import Polysemy.Input
import Polysemy.Output

import HttpEffect
import qualified UnambiguiousStrings as US

data Snake = 
    Snake (Sem '[
                HttpEffect
               ] US.SText)

snakeToIO :: Snake -> IO US.SText
snakeToIO (Snake s) = runM . httpToIO $ ((raiseUnder s) )
