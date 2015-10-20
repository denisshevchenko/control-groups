module Types (
      SMap
    , CGroupName
    , TaskPID
) where

import qualified Data.Map.Lazy as M

type SMap       = M.Map String String
type CGroupName = String
type TaskPID    = String
