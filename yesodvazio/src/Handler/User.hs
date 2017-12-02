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

formUsuario :: Form (,,,) 
formUsuario = renderDivs $ (,,,)
    <$> areq textField "Nome: " Nothing
    <*> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    -- <*> areq userCategoryField "Tipo do usuario: " Nothing
    
getUsuarioR :: Handler Html
getUsuarioR = do 
    (widget,enctype) <- generateFormPost formUsuario
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{HomeR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postUsuarioR :: Handler Html
postUsuarioR = do 
    ((resultado,_),_) <- runFormPost formUsuario
    case resultado of 
        FormSuccess usr -> do 
            _ <- runDB $ insert usr
            setMessage [shamlet|
                <div> 
                    Usuario com sucesso!
            |]
            redirect UserR
        _ -> redirect HomeR
