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
formUser = renderDivs $ User
    <$> areq textField "nickName: " Nothing
    <*> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    -- a categoria do usuario deve ser enviada de forma automatica
    -- não e o suario que escolhe
   -- <*> areq keyField "Tipo do usuario: " Nothing
    
getUserR :: Handler Html
getUserR = do 
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

postUserR :: Handler Html
postUserR = do 
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
