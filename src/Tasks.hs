module Tasks (
    showListOfTasksInCGroup
) where

import qualified Data.Map.Lazy      as M
import           Data.Maybe
import           Network.FastCGI

type SMap = M.Map String String

showListOfTasksInCGroup :: SMap -> CGI CGIResult
showListOfTasksInCGroup queryData = do
    setHeader "Content-type" "application/json"
    output $ "Tasks in the cgroup '" 
             ++ fromJust (M.lookup "group" queryData)
             ++ "': ..."
