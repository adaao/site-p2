{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Publication where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getPublicationR :: Handler Html
getPublicationR = do
    defaultLayout $(whamletFile "templates/Thread.hamlet")