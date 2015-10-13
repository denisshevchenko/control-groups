module PlaceTask (
    placeTaskIntoCGroup
) where

import qualified Data.Map.Lazy      as M
import           Data.Maybe
import           Network.FastCGI

type SMap = M.Map String String

placeTaskIntoCGroup :: SMap -> CGI CGIResult
placeTaskIntoCGroup queryData = do
    setHeader "Content-type" "application/json"
    output $ "Place task with PID '" 
             ++ fromJust (M.lookup "task" queryData)
             ++ "' into cgroup '" 
             ++ fromJust (M.lookup "intogroup" queryData)
             ++ "': ..."
