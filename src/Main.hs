{-# LANGUAGE MultiWayIf #-}

module Main (
    main
) where

import Parsers
import Invalid
import CGroups
import PlaceTask
import Tasks

import Data.Map.Lazy      
import Network.FastCGI

main :: IO ()
main = runFastCGI cGroupWork

cGroupWork :: CGI CGIResult
cGroupWork = requestMethod >>= \actualHTTPMethod ->
    if | actualHTTPMethod == "GET"  -> handleGETrequest
       | actualHTTPMethod == "POST" -> handlePOSTrequest
       | otherwise                  -> reportAboutUnsupportedMethod

handleGETrequest :: CGI CGIResult
handleGETrequest = queryString >>= \rawQuery ->
    let queryData = parse rawQuery
    in if | member "list"  queryData -> showListOfCGroups
          | member "group" queryData -> showListOfTasksInCGroup queryData
          | otherwise                -> reportAboutInvalidQuery rawQuery

handlePOSTrequest :: CGI CGIResult
handlePOSTrequest = getInputs >>= \postInputData -> placeTaskIntoCGroup . fromList $ postInputData
