module Main where

import Network.FastCGI

cgroupWork :: CGI CGIResult
cgroupWork = do
    setHeader "Content-type" "application/json"
    output "{ \"hello\" : \"world\" }"

main :: IO ()
main = runFastCGI cgroupWork

