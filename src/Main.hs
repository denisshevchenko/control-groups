{-# LANGUAGE MultiWayIf #-}

module Main (
    main
) where

import Data.Map.Lazy      
import Network.FastCGI

import Parsers
import Invalid (reportAboutInvalidQuery)
import CGroups
import PlaceTask
import Tasks

main :: IO ()
main = runFastCGI cGroupWork

cGroupWork :: CGI CGIResult
cGroupWork = queryString >>= \rawQuery ->
    let queryData = parse rawQuery in
    if | member "list"  queryData -> showListOfCGroups
       | member "group" queryData -> showListOfTasksInCGroup queryData
       | member "task"  queryData -> placeTaskIntoCGroup queryData
       | otherwise                -> reportAboutInvalidQuery rawQuery
