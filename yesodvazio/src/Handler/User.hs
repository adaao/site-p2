{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.Usuario where

import Import
import Database.Persist.Postgresql

formUsuario :: Form Usuario 
formUsuario = renderDivs $ Usuario 
    <$> areq textField "Nome: " Nothing
    <*> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    <*> areq dayField      "Data de Nasc: " Nothing
    
getUsuarioR :: Handler Html
getUsuarioR = do 
    (widget,enctype) <- generateFormPost formUsuario
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{UsuarioR} method=post>
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
            redirect UsuarioR
        _ -> redirect HomeR