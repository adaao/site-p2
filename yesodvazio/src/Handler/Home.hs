{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import

formLogin :: Form (Text,Text) 
formLogin = renderBootstrap $ (,) 
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

getHomeR :: Handler Html
getHomeR = do
  (widget,enctype) <- generateFormPost formLogin
  defaultLayout $(whamletFile "templates/HomePage.hamlet")
