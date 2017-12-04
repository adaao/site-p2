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

formLogin :: Form (Text,Text) 
formLogin = renderDivs $ (,) 
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    
getLogarR :: Handler Html
getLogarR = do 
    (widget,enctype) <- generateFormPost formLogin
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form method=post>
                ^{widget}
                <input type="submit" value="Login">
        |]

autentica :: Text -> Text -> HandlerT App IO (Maybe (Entity User))
autentica email senha = runDB $ selectFirst [UserEmail ==. email
                                            ,UserPassword ==. senha] []
                                            
postLogarR :: Handler Html
postLogarR = do 
    ((resultado,_),_) <- runFormPost formLogin
    case resultado of
        FormSuccess ("root@root.com","root") -> do 
            setSession "_NOME" "admin"
            redirect UserR
        FormSuccess (email,password) -> do 
            talvezUser <- autentica email password
            case talvezUser of 
                Nothing -> do 
                    setMessage [shamlet|
                        <div> 
                            Usuario nao encontrado/Senha invalida!
                    |]
                    redirect LogarR
                Just (Entity _ usr) -> do 
                    setSession "_NOME" (userNickName usr)
                    redirect HomeR
            redirect UserR
        _ -> redirect HomeR

postLogSairR :: Handler Html
postLogSairR = do 
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
                    redirect HomeR
                Just (Entity _ usr) -> do 
                    setSession "_NOME" (userNickName usr)
                    redirect HomeR
            redirect HomeR
        _ -> redirect HomeR