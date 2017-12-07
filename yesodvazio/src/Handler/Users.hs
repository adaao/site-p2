{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Users where

import Import
import Database.Persist.Postgresql

formUser :: Form Users
formUser = undefined 

getUserR :: Handler Html
getUserR = undefined 

postUserR :: Handler Html
postUserR = undefined

postCreateUserR :: Handler Value
postCreateUserR = do
    newUser <- requireJsonBody :: Handler Users
    newUserId <- runDB $ insert newUser
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey newUserId)])
    
getReadUserR :: UsersId -> Handler Value
getReadUserR userId = do
    user <- runDB $ get404 userId
    sendStatusJSON ok200 (object ["resp" .= (toJSON user)])
    
putUpdateUserR :: UsersId -> Handler Value
putUpdateUserR userToBeUpdatedId = do
    _ <- runDB $ get404 userToBeUpdatedId
    updatedUser <- requireJsonBody :: Handler Users
    runDB $ replace userToBeUpdatedId updatedUser
    sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey userToBeUpdatedId)])
    
getUserNameByUsersId :: UsersId -> Widget
getUserNameByUsersId uid = do
    user <- handlerToWidget $ runDB $ get404 uid
    [whamlet|<span>#{usersNickName user}|]