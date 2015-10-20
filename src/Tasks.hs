{-# LANGUAGE OverloadedStrings #-}

module Tasks (
    showListOfTasksInCGroup
) where

import           Invalid                            (reportAboutInvalidTasksFile) 
import           Types

import           Control.Applicative                (many)
import           Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString                    as B
import qualified Data.ByteString.Lazy               as LB
import qualified Codec.Binary.UTF8.String           as U
import           Data.Aeson
import           Data.Aeson.Encode.Pretty           (encodePretty)
import           System.FilePath.Posix              ((</>))
import           Control.Exception
import qualified Data.Map.Lazy                      as M
import           Data.Maybe
import           Network.FastCGI

-- Helper type for Attoparsec and Aeson.
type TasksPIDs = [Int]

data Tasks = Tasks CGroupName TasksPIDs

aPIDParser :: Parser Int
aPIDParser = decimal

aPIDsFileParser :: Parser TasksPIDs
aPIDsFileParser = many $ aPIDParser <* endOfLine

-- Instance for JSON creation.
instance ToJSON Tasks where
    toJSON (Tasks name aPIDs) = object [ "cgroup" .= name
                                       , "tasks"  .= aPIDs
                                       ]

-- Show list of tasks in particular cgroup. Based on content of /sys/fs/cgroup/NAME/tasks.
showListOfTasksInCGroup :: SMap -> CGI CGIResult
showListOfTasksInCGroup queryData = do
    -- This is GET method...
    let nameOfCGroup    = fromJust (M.lookup "group" queryData)
        pathToTasksFile = "/sys/fs/cgroup" </> nameOfCGroup </> "tasks"
    tasksPIDs <- liftIO $ B.readFile pathToTasksFile `catch` possibleErrors
    let aPIDsList = parseOnly aPIDsFileParser tasksPIDs
    case aPIDsList of
        Left  _     -> reportAboutInvalidTasksFile pathToTasksFile
        Right aPIDs -> showListOfTasks nameOfCGroup aPIDs

possibleErrors :: IOException -> IO B.ByteString
possibleErrors _ = return ""

showListOfTasks :: CGroupName -> TasksPIDs -> CGI CGIResult
showListOfTasks nameOfCGroup aPIDs = do
    setHeader "Content-type" "application/json"
    output . U.decode . LB.unpack . encodePretty $ Tasks nameOfCGroup aPIDs
