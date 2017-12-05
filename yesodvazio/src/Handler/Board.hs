{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Board where

import Import
import Text.Hamlet
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getBoardR :: Handler Html
getBoardR = do
  defaultLayout $(whamletFile "templates/Board.hamlet")
{-

getBoardR = do
  pageFooter <- 
    toWidget [hamlet|
      <footer class="col-lg-12">
        <div class="text-center">
          <p class="text-muted">Copyright &copy; 2017
    |]
  setTitle "Haskell Chan"
  toWidgetHead
    [hamlet|
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
    |]
    addStylesheet $ StaticR css_bootstrap_min_css
    addStylesheetRemote $ "https://fonts.googleapis.com/css?family=Indie+Flower"
    addScript $ StaticR js_jquery_min_js
    addScript $ StaticR js_bootstrap_bundle_min_js
  toWidgetBody
    [hamlet|
      <p>Nada
    |]
-}

--type Widget = WidgetT MyApp IO ()

{-
sidebarWidget :: [Board] -> Widget
sidebarWidget boards = do
  toWidget [hamlet|
    <ul class="sidebar-nav">
      <li class="sidebar-brand menu-title">
        <a href=@{HomeR}>Haskell Chan
      $if null boards
        <li class="text-center menu-item">
          <a href=@{HomeR}>Não há menu para exibir
      $forall Board id boardName <- boards
        <li class="text-center menu-item">
          <a href=@{ThreadR}>#{boardName}
  |]
-}