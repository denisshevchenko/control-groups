{-# LANGUAGE OverloadedStrings #-}

module CGroups (
    showListOfCGroups
) where

import qualified Data.List                  as L
import qualified Data.ByteString.Lazy       as LB
import qualified Codec.Binary.UTF8.String   as U
import           Data.Aeson
import           Data.Aeson.Encode.Pretty   (encodePretty)
import           System.FilePath.Posix      (takeFileName)
import           System.Directory           (getDirectoryContents)
import           Control.Exception
import           Network.FastCGI

data CGroups = CGroups [FilePath]

-- Instance for JSON creation.
instance ToJSON CGroups where
    toJSON (CGroups aCGroups) = object [ "cgroups" .= aCGroups ]

-- Show list of available cgroups. Based on content of /sys/fs/cgroup.
showListOfCGroups :: CGI CGIResult
showListOfCGroups = do
    -- This is GET method...
    setHeader "Content-type" "application/json"
    cGroups <- liftIO $ getDirectoryContents "/sys/fs/cgroup/" `catch` possibleErrors
    let names = filter notHiddenPaths (takeFileName <$> cGroups)
    output . U.decode . LB.unpack . encodePretty $ CGroups names

possibleErrors :: IOException -> IO [FilePath]
possibleErrors _ = return []

notHiddenPaths :: FilePath -> Bool
notHiddenPaths aPath = not $ "." `L.isPrefixOf` aPath
