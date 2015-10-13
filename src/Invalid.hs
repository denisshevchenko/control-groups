module Invalid (
    reportAboutInvalid
) where

import Network.FastCGI

reportAboutInvalid :: String -> CGI CGIResult
reportAboutInvalid rawQuery = do
    setHeader "Content-type" "text/plain"
    setStatus 400 "Bad Request"
    output $ "Sorry, your request '" 
             ++ rawQuery 
             ++ "' is invalid. Please refer to documentation."
