{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE LambdaCase, BlockArguments #-}
{-# LANGUAGE GADTs, FlexibleContexts, TypeOperators, DataKinds, PolyKinds, ScopedTypeVariables #-}

module Snake (

) where

import Polysemy
import Polysemy.Input
import Polysemy.Output

import HttpEffect
import qualified UnambiguiousStrings as US

data Snake = 
    Snake (Sem [
                HttpEffect
               ] Text)

snakeToIO :: Snake -> IO US.SText
snakeToIO (Snake s) = runM . httpToIO $ s
