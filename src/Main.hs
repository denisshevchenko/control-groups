{-# LANGUAGE MultiWayIf #-}

module Main where

import qualified Data.Map.Lazy      as M
import           Network.FastCGI

import           Parsers
import           Invalid
import           CGroups
import           PlaceTask
import           Tasks

main :: IO ()
main = runFastCGI cGroupWork

cGroupWork :: CGI CGIResult
cGroupWork = queryString >>= \rawQuery ->
    let queryData = parse rawQuery in
    if | M.member "list" queryData  -> showListOfCGroups
       | M.member "group" queryData -> showListOfTasksInCGroup queryData
       | M.member "task" queryData  -> placeTaskIntoCGroup queryData
       | otherwise                  -> reportAboutInvalid rawQuery
