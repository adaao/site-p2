{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Reply where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql
-- este arquivo cria o reply do post
postCreateReplyR :: Handler Value
postCreateReplyR = do
    newObj <- requireJsonBody :: Handler Reply
    newObjId <- runDB $ insert newObj
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey newObjId)])
