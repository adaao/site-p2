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
-- este arquivo me deu dor de cabeca, mas ele e importante    
getLogarR :: Handler Html
getLogarR = do 
    (widget,enctype) <- generateFormPost formLogin
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{LogarR} method=post>
                ^{widget}
                <input type="submit" value="Login">
        |]

autentica :: Text -> Text -> HandlerT App IO (Maybe (Entity Users))
autentica email senha = runDB $ selectFirst [UsersEmail ==. email
                                            ,UsersPassword ==. senha] []
                                            
postLogarR :: Handler Html
postLogarR = do 
    ((resultado,_),_) <- runFormPost formLogin
    case resultado of
        FormSuccess ("root@root.com","root") -> do 
            setSession "admin" "_NOME" 
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
                    setSession (usersNickName usr) "_NOME" 
                    redirect $ BoardR "hs"
            --redirect UserR
        _ -> do
            print "erro"
            redirect HomeR

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
                    deleteSession (usersNickName usr)
                    redirect HomeR
            redirect HomeR
        _ -> redirect HomeR