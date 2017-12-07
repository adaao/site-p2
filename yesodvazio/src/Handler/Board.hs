{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Board where

import Import
import Handler.Publication
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getBoardR :: Text -> Handler Html
getBoardR sigla = do
  bdata <- runDB $ selectFirst [ BoardSigla ==. sigla ] []
  case bdata of
    Nothing -> defaultLayout [whamlet| <div>Erro 404|]
    Just (Entity boardid board) -> 
      defaultLayout $(whamletFile "templates/Board.hamlet")
    
postCreateBoardR :: Handler Value
postCreateBoardR = do
  newBoard <- requireJsonBody :: Handler Board
  newBoardId <- runDB $ insert newBoard
  sendStatusJSON created201 (object ["resp" .= (fromSqlKey newBoardId)])

getListBoardsR :: Handler Value
getListBoardsR = undefined
