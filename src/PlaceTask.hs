{-# LANGUAGE OverloadedStrings #-}

module PlaceTask (
    placeTaskIntoCGroup
) where

import qualified Data.ByteString.Lazy               as LB
import qualified Codec.Binary.UTF8.String           as U
import           Data.Aeson
import           Data.Aeson.Encode.Pretty           (encodePretty)
import           System.FilePath.Posix              ((</>))
import           System.Directory                   (doesFileExist)
import           Control.Exception
import qualified Data.Map.Lazy                      as M
import           Data.Maybe
import           Data.Char
import           System.Process
import           System.Exit
import           Network.FastCGI
import           Types

data AttachedTask = AttachedTask CGroupName TaskPID
data NonAttachedTask = NonAttachedTask CGroupName TaskPID

successfullyStatus :: String
successfullyStatus = "successfully"

failureStatus :: String
failureStatus = "failure"

-- Instances for JSON creation.
instance ToJSON AttachedTask where
    toJSON (AttachedTask name aPID) = object [ "cgroup" .= name
                                             , "pid"    .= aPID
                                             , "status" .= successfullyStatus
                                             ]

instance ToJSON NonAttachedTask where
    toJSON (NonAttachedTask name aPID) = object [ "cgroup" .= name
                                                , "pid"    .= aPID
                                                , "status" .= failureStatus
                                                ]

-- Show list of tasks in particular cgroup. Based on content of /sys/fs/cgroup/NAME/tasks.
placeTaskIntoCGroup :: SMap -> CGI CGIResult
placeTaskIntoCGroup queryData = do
    setHeader "Content-type" "application/json"
    let taskPID           = fromJust (M.lookup "task" queryData)
        -- Make sure that taskPID is just a number...
        taskPIDIsANumber  = all isDigit taskPID
        nameOfCGroup      = fromJust (M.lookup "intogroup" queryData)
        pathToTasksFile   = "/sys/fs/cgroup" </> nameOfCGroup </> "tasks"
        attachTaskCommand = "echo " ++ taskPID ++ " >> " ++ pathToTasksFile
    -- Make sure that nameOfCGroup is correct name of cgroup-file...
    cGroupActuallyExists <- liftIO $ doesFileExist pathToTasksFile
    if taskPIDIsANumber && cGroupActuallyExists
    then do
        -- At this point we already know that attachTaskCommand is safe.
        resultCode <- liftIO $ system attachTaskCommand `catch` possibleErrors
        case resultCode of
            ExitSuccess   -> itsDone nameOfCGroup taskPID
            ExitFailure _ -> failure nameOfCGroup taskPID
    else
        failure nameOfCGroup taskPID

possibleErrors :: IOException -> IO ExitCode
possibleErrors _ = return $ ExitFailure 1

itsDone :: CGroupName -> TaskPID -> CGI CGIResult
itsDone nameOfCGroup taskPID =
    output . U.decode . LB.unpack . encodePretty $ AttachedTask nameOfCGroup taskPID

failure :: CGroupName -> TaskPID -> CGI CGIResult
failure nameOfCGroup taskPID = do
    setStatus 500 "Internal Server Error"
    output . U.decode . LB.unpack . encodePretty $ NonAttachedTask nameOfCGroup taskPID
