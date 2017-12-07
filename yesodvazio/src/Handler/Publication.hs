{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Publication where

import Import
import Database.Persist.Postgresql
import Handler.Users

getPublicationR :: PublicationId -> Handler Html
getPublicationR pubId = do
    publication <- runDB $ selectFirst [ PublicationId ==. pubId ] []
    case publication of
        Nothing -> defaultLayout $ [whamlet|<div>Erro 404|]
        Just (Entity pid pub) -> do
            board <- runDB $ selectFirst [ BoardId ==. (publicationBoardid pub) ] []
            case board of
              Just (Entity bid bod) -> defaultLayout $(whamletFile "templates/Thread.hamlet")
              _ -> defaultLayout $ [whamlet|<div>Erro fatal|]

postCreatePublicationR :: Handler Value
postCreatePublicationR = do
    newObj <- requireJsonBody :: Handler Publication
    newObjId <- runDB $ insert newObj
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey newObjId)])
 
getListPublicationByBoardId :: BoardId -> Widget
getListPublicationByBoardId bid = do
    threads <- handlerToWidget $ runDB $ selectList [ PublicationBoardid ==. bid ] [Desc PublicationId]
    [whamlet|
        <div class="card-deck">
            $forall Entity pid pub <- threads
                <div class="card">
                    <div class="card-header">
                        <span class="float-left">
                        <span class="float-right">#{formatTime defaultTimeLocale "%d/%m/%Y" $ publicationPublicationdate pub}
                    <div class="card-body">
                        <h4 class="card-title">#{publicationTitle pub}
                        <h6 class="card-subtitle mb-2 text-muted">^{getUserNameByUsersId $ publicationUserid pub}
                        <p class="card-text">#{publicationContent pub}
                    <div class="card-footer">
                        <button type="button" class="btn btn-primary float-right">
                            <a href=@{PublicationR pid}>Abrir
    |]

sidebarWidget :: Widget
sidebarWidget = do
  boards <- handlerToWidget $ runDB $ selectList [] [Asc BoardId]
  [whamlet|
    <ul class="sidebar-nav">
      <li class="sidebar-brand menu-title">
        <a href=@{HomeR}>Haskell Chan
      $forall Entity boardid board <- boards
        <li class="text-center menu-item">
          <a href=@{BoardR $ boardSigla board}">/#{boardSigla board}/
  |]
  
getListReply :: PublicationId -> Publication -> Widget 
getListReply pid pub = do
  replies <- handlerToWidget $ runDB $ selectList [ ReplyPublicationid ==. pid ] [Asc ReplyId]
  [whamlet|
    <div class="posts">
      <div class="card w100 bg-light mb-3">
        <div class="card-header op-header">
          <span class="float-left">#{publicationTitle pub} - ^{getUserNameByUsersId $ publicationUserid pub}
          <span class="float-right">#{formatTime defaultTimeLocale "%d/%m/%Y" $ publicationPublicationdate pub}
        <div class="card-body">
          <p class="card-text">#{publicationContent pub}
      $forall Entity rid reply <- replies
        <div class="card w100">
          <div class="card-header">
            <span class="float-left">#{publicationTitle pub} - ^{getUserNameByUsersId $ replyUserid reply}
            <span class="float-right">#{formatTime defaultTimeLocale "%d/%m/%Y %H:%M:%S" $ replyReplyDate reply}
          <div class="card-body">
            <p class="card-text">#{replyContent reply}
  |]