{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Board where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getBoardR :: Handler Html
getBoardR = do
  defaultLayout $(whamletFile "templates/board.hamlet")
    