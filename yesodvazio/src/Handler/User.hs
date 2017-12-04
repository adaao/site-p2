{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.User where

import Import
import Database.Persist.Postgresql

formUser :: Form User
formUser = undefined 

{-renderDivs $ User
    <$> areq textField "nickName: " Nothing
    <*> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    -- a categoria do usuario deve ser enviada de forma automatica
    -- não e o suario que escolhe
   -- <*> areq keyField "Tipo do usuario: " Nothing
-}

getUserR :: Handler Html
getUserR = undefined 
{-do 
    (widget,enctype) <- generateFormPost formUser
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{HomeR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]
-}
postUserR :: Handler Html
postUserR = undefined
{-do 
    ((resultado,_),_) <- runFormPost formUser
    case resultado of 
        FormSuccess usr -> do 
            _ <- runDB $ insert usr
            setMessage [shamlet|
                <div> 
                    Cadastro realizado com sucess!
            |]
            redirect UserR
        _ -> redirect HomeR
-}

postCreateUserR :: Handler Value
postCreateUserR = do
    newUser <- requireJsonBody :: Handler User
    newUserId <- runDB $ insert newUser
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey newUserId)])
    
getReadUserR :: UserId -> Handler Value
getReadUserR userId = do
    user <- runDB $ get404 userId
    sendStatusJSON ok200 (object ["resp" .= (toJSON user)])
    
putUpdateUserR :: UserId -> Handler Value
putUpdateUserR userToBeUpdatedId = do
    _ <- runDB $ get404 userToBeUpdatedId
    updatedUser <- requireJsonBody :: Handler User
    runDB $ replace userToBeUpdatedId updatedUser
    sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey userToBeUpdatedId)])
    

