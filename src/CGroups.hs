module CGroups (
    showListOfCGroups
) where

import Network.FastCGI

showListOfCGroups :: CGI CGIResult
showListOfCGroups = do
    setHeader "Content-type" "application/json"
    output "List of cgroups: ..."
