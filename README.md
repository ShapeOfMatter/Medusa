# Medusa
A self-host-able "serverless" framework for Haskell.

## Goals
- User uploads a text file containing Haskell code.
- User gets back a web path.
- Requests to that path cause the code in question to execute, possibly taking arguments from the request, possibly returning some response.
- Safety, authenticaiton, good UX, etc. 

## Summary

Very loosely, `medusa` reads a string which evaluates to a request handler, and returns a Wai server exposing that handler.

```haskell
Medusa.medusa :: [System.Eval.Utils.Import] -> String -> IO (Either String Network.Wai.Application)
```
Whether or not this is useful will probably be a matter of opinion.

```haskell
imports = []
handler = "const (pure \"Hello World!\" :: Medusa.Face)"

main = do
  compiled <- Medusa.medusa imports handler
  either putStrLn (Network.Wai.Handler.Warp.run 8080) compiled
```

## Todo
everything
