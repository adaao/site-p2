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

postCreateReplyR :: Handler Value
postCreateReplyR = do
    newObj <- requireJsonBody :: Handler Reply
    newObjId <- runDB $ insert newObj
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey newObjId)])

{-
getListReplyR :: PublicationId -> Handler Value
getListReplyR pid = do
    publicationList <- runDB $ selectList [PublicationId .== pid] [Asc PublicationTitle]
    sendStatusJSON ok200 (object ["resp" .= (toJSON publicationList)])

getReadReplyR :: PublicationId -> Handler Value
getReadReplyR objId = do
    obj <- runDB $ get404 objId
    sendStatusJSON ok200 (object ["resp" .= (toJSON obj)])

putUpdateReplyR :: PublicationId -> Handler Value
putUpdateReplyR objId = do
    _ <- runDB $ get404 objId
    updatedObj <- requireJsonBody :: Handler Reply
    runDB $ replace objId updatedObj
    sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey objId)])
-}