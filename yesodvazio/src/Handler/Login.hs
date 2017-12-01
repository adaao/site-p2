{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.Login where

import Import
import Database.Persist.Postgresql

formCliente :: Form (Text,Text) 
formCliente = renderDivs $ (,) 
    <*> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    
getLoginR :: Handler Html
getLoginR = do 
    (widget,enctype) <- generateFormPost formLogin
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{LoginR} method=post>
                ^{widget}
                <input type="submit" value="Login">
        |]

autentica :: Text -> Text -> HandlerT App IO (Maybe Cliente)
autentica email senha = runDB $ selectFirst [ClienteEmail ==. email
                                            ,ClienteSenha ==. senha] []

postLoginR :: Handler Html
postLoginR = do 
    ((resultado,_),_) <- runFormPost formLogin
    case resultado of 
        FormSuccess (email,senha) -> do 
            talvezCliente <- autentica email senha
            case talvezCliente of 
                Nothing -> do 
                    setMessage [shamlet|
                        <div> 
                            Usuario nao encontrado/Senha invalida!
                    |]
                    redirect LoginR
                Just cli -> do 
                    setSession "_NOME" (clienteNome cli)
                    redirect HomeR
            redirect ClienteR
        _ -> redirect HomeR