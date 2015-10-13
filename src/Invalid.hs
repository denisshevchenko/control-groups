module Invalid (
    reportAboutInvalid
) where

import Network.FastCGI

reportAboutInvalid :: String -> CGI CGIResult
reportAboutInvalid rawQuery = do
    setHeader "Content-type" "text/html"
    setStatus 400 "Bad Request"
    output $ "<div style=\"text-align: center; padding-top: 30px;\"><h2>Sorry, your request '"
             ++ rawQuery 
             ++ "' is invalid</h2><br/>Please refer to documentation.</div>"
