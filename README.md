# Medusa
A self-host-able "serverless" framework for Haskell.

## Goals
- User uploads a text file containing Haskell code.
- User gets back a web path.
- Requests to that path cause the code in question to execute, possibly taking arguments from the request, possibly returning some response.
- Safety, authenticaiton, good UX, etc. 

## Summary

Very loosely, `medusa` reads a string which evaluates to a request handler (or list of handlers), and returns a Wai server exposing those handlers.
```haskell
medusa :: [System.Eval.Utils.Import] -> String -> IO (Either String Network.Wai.Application)
```

## Todo
everything
