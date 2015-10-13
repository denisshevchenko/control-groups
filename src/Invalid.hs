module Invalid (
      reportAboutInvalidQuery
    , reportAboutInvalidTasksFile
) where

import Network.FastCGI

reportAboutInvalidQuery :: String -> CGI CGIResult
reportAboutInvalidQuery rawQuery = do
    setHeader "Content-type" "text/html"
    setStatus 400 "Bad Request"
    output $ "<div style=\"text-align: center; padding-top: 30px;\"><h2>Sorry, your request '"
             ++ rawQuery 
             ++ "' is invalid</h2><br/>Please refer to documentation.</div>"

reportAboutInvalidTasksFile :: FilePath -> CGI CGIResult
reportAboutInvalidTasksFile pathToTasksFile = do
    setHeader "Content-type" "text/html"
    setStatus 500 "Internal Server Error"
    output $ "<div style=\"text-align: center; padding-top: 30px;\"><h2>Sorry, tasks file '"
             ++ pathToTasksFile 
             ++ "' has invalid format</h2><br/>Please check it.</div>"
