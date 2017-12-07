{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.UserCategory where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getReadUserCategoryR :: UserCategoryId -> Handler Value
getReadUserCategoryR userCategoryId = do
  userCategory <- runDB $ get404 userCategoryId
  sendStatusJSON ok200 (object ["resp" .= (toJSON userCategory)])

postCreateUserCategoryR :: Handler Value
postCreateUserCategoryR = do
  userType <- requireJsonBody :: Handler UserCategory
  userCategoryId <- runDB $ insert userType
  sendStatusJSON created201 (object ["resp" .= (fromSqlKey userCategoryId)])

putUpdateUserCategoryR :: UserCategoryId -> Handler Value
putUpdateUserCategoryR categoryToBeUpdatedId = do
    _ <- runDB $ get404 categoryToBeUpdatedId
    categoryUpdated <- requireJsonBody :: Handler UserCategory
    runDB $ replace categoryToBeUpdatedId categoryUpdated
    sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey categoryToBeUpdatedId)])
    
  
--mostra as categorias
getListUserTypeR :: Handler Value
getListUserTypeR = do
  userTypeList <- runDB $ selectList [] [Asc UserCategoryUserType]
  sendStatusJSON ok200 (object ["resp" .= (toJSON  userTypeList)])

