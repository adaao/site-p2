{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.UserCategory where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getListUserTypeR :: Handler Value
getListUserTypeR = do
  userTypeList <- runDB $ selectList [] [Asc UserCategoryUserType]
  sendStatusJSON ok200 (object ["resp" .= (toJSON  userTypeList)])

postInsertUserTypeR :: Handler Value
postInsertUserTypeR = do
  userType <- requireJsonBody :: Handler UserCategory
  userCategoryId <- runDB $ insert userType
  sendStatusJSON created201 (object ["resp" .= (fromSqlKey userCategoryId)])

putUpdateUserTypeR :: UserCategoryId -> Text -> Handler Value
putUpdateUserTypeR userCategoryId updatedUserType = do
  _ <- runDB $ get404 userCategoryId
  runDB $ update userCategoryId [UserCategoryUserType =. updatedUserType]
  sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey userCategoryId)])
