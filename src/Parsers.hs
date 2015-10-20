module Parsers (
    parse
) where

import qualified Data.Map.Lazy      as M
import           Data.List.Split
import           Data.List

type SMap = M.Map String String

parse :: String -> SMap
parse rawQuery
    | rawQuery == "list"                = M.fromList [("list", "")]
    | "tasks"     `isInfixOf` rawQuery  = parseTasksFrom rawQuery
    | "intogroup" `isInfixOf` rawQuery  = parseTaskMovingFrom rawQuery
    | otherwise                         = M.empty

parseTasksFrom :: String -> SMap
parseTasksFrom rawQuery =
    if length pairsOfParameters /= 2 then
        M.empty
    else
        let [pairWithGroup] = filter (isPrefixOf "group") pairsOfParameters
            incorrectForm   = not (singleEqualSign pairWithGroup)
            Just cGroupName = stripPrefix "group=" pairWithGroup
        in if incorrectForm || null cGroupName then
               M.empty
           else
               M.fromList [("group", cGroupName)]
    where pairsOfParameters = splitOnBaseSeparator rawQuery

parseTaskMovingFrom :: String -> SMap
parseTaskMovingFrom rawQuery = 
    if length pairsOfParameters /= 2 then
        M.empty
    else
        let [pairWithTaskId]     = filter (isPrefixOf "task=") pairsOfParameters
            [pairWithCGroupName] = filter (isPrefixOf "intogroup=") pairsOfParameters
            incorrectForm        =    not (singleEqualSign pairWithTaskId)
                                   || not (singleEqualSign pairWithCGroupName)
            Just taskId          = stripPrefix "task=" pairWithTaskId
            Just cGroupName      = stripPrefix "intogroup=" pairWithCGroupName
        in if incorrectForm || null taskId || null cGroupName then
               M.empty
           else
               M.fromList [("task", taskId), ("intogroup", cGroupName)]
    where pairsOfParameters = splitOnBaseSeparator rawQuery

splitOnBaseSeparator :: String -> [String]
splitOnBaseSeparator = splitOn "&"

singleEqualSign :: String -> Bool
singleEqualSign pairWithParameter = length (splitOn "=" pairWithParameter) == 2
