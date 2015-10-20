module Invalid (
      reportAboutInvalidQuery
    , reportAboutInvalidTasksFile
    , reportAboutInvalidRequestMethod
    , reportAboutUnsupportedMethod
    , reportAboutEmptyPOSTRequest
) where

import Network.FastCGI
import Data.List        (unlines)

reportAboutInvalidQuery :: String -> CGI CGIResult
reportAboutInvalidQuery rawQuery = do
    setHeader "Content-type" "text/html"
    setStatus 400 "Bad Request"
    output $ unlines [ "<div style=\"text-align: center; padding-top: 30px;\">"
                     , "<h2>Sorry, your GET-request '"
                     , rawQuery 
                     , "' is invalid</h2><br/>Please refer to documentation.</div>"
                     ]

reportAboutInvalidTasksFile :: FilePath -> CGI CGIResult
reportAboutInvalidTasksFile pathToTasksFile = do
    setHeader "Content-type" "text/html"
    setStatus 500 "Internal Server Error"
    output $ unlines [ "<div style=\"text-align: center; padding-top: 30px;\">"
                     , "<h2>Sorry, tasks file '"
                     , pathToTasksFile 
                     , "' has invalid format</h2><br/>Please check it.</div>"
                     ]

reportAboutInvalidRequestMethod :: CGI CGIResult
reportAboutInvalidRequestMethod = do
    setHeader "Content-type" "text/html"
    setStatus 405 "Method Not Allowed"
    output $ unlines [ "<div style=\"text-align: center; padding-top: 30px;\">"
                     , "<h2>Method is not allowed</h2>"
                     , "Method 'GET' is not allowed for this request, use 'POST' instead."
                     , "</div>"
                     ]

reportAboutUnsupportedMethod :: CGI CGIResult
reportAboutUnsupportedMethod = do
    setHeader "Content-type" "text/html"
    setStatus 405 "Method Not Allowed"
    output $ unlines [ "<div style=\"text-align: center; padding-top: 30px;\">"
                     , "<h2>Method is not allowed</h2>"
                     , "This server supports only 'GET' and 'POST' methods."
                     , "</div>"
                     ]

reportAboutEmptyPOSTRequest :: CGI CGIResult
reportAboutEmptyPOSTRequest = do
    setHeader "Content-type" "text/html"
    setStatus 400 "Bad Request"
    output $ unlines [ "<div style=\"text-align: center; padding-top: 30px;\">"
                     , "<h2>Empty POST-request</h2>"
                     , "Your POST-request doesn't contain any data.</div>"
                     ]
