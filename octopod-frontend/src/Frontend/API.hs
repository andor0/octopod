{-|
Module      : Frontend.API
Description : API requests.

This module contains client functions that perform API requests (these functions
are generated from the servant API) and functions that work with request
results.
-}

{-# LANGUAGE CPP #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE PartialTypeSignatures #-}

module Frontend.API where

import           Control.Lens
import           Data.Aeson
import           Data.Proxy
import           Data.Text as T
import           GHC.TypeLits
import           Reflex.Dom as R
import           Servant.API as S
import           Servant.Reflex as SR

import           Common.Types
import           Frontend.GHCJS
import           Octopod.API

-- | 'apiClients' generates API requests. Before each request the API host and
-- API authentication token are read from session storage.
apiClients
  :: forall t m. MonadWidget t m
  => SR.Client t m API ()
apiClients =
  clientWithOpts
    (Proxy @API)
    (Proxy @m)
    (Proxy @())
    (constDyn host)
    tweakRequest
  where
    tweakRequest = ClientOptions $ \req -> do
      url <- getAppUrl
      auth <- getAppAuth
      pure $ req
        & xhrRequest_config
        . xhrRequestConfig_headers
        . at "Authorization" ?~ auth
        & xhrRequest_url %~ (T.append url)
    host = SR.BasePath "/"


listEndpoint
  :: MonadWidget t m
  => Event t ()
  -> m (Event t (ReqResult () [DeploymentFullInfo]))
createEndpoint
  :: MonadWidget t m
  => Dynamic t (Either Text Deployment)
  -> Event t ()
  -> m (Event t (ReqResult () CommandResponse))
archiveEndpoint
  :: MonadWidget t m
  => Dynamic t (Either Text DeploymentName)
  -> Event t ()
  -> m (Event t (ReqResult () CommandResponse))
updateEndpoint
  :: MonadWidget t m
  => Dynamic t (Either Text DeploymentName)
  -> Dynamic t (Either Text DeploymentUpdate)
  -> Event t ()
  -> m (Event t (ReqResult () CommandResponse))
infoEndpoint
  :: MonadWidget t m
  => Dynamic t (Either Text DeploymentName)
  -> Event t ()
  -> m (Event t (ReqResult () [DeploymentInfo]))
fullInfoEndpoint
  :: MonadWidget t m
  => Dynamic t (Either Text DeploymentName)
  -> Event t ()
  -> m (Event t (ReqResult () DeploymentFullInfo))
statusEndpoint
  :: MonadWidget t m
  => Dynamic t (Either Text DeploymentName)
  -> Event t ()
  -> m (Event t (ReqResult () CurrentDeploymentStatus))
restoreEndpoint
  :: MonadWidget t m
  => Dynamic t (Either Text DeploymentName)
  -> Event t ()
  -> m (Event t (ReqResult () CommandResponse))
pingEndpoint
  :: MonadWidget t m
  => Event t ()
  -> m (Event t (ReqResult () NoContent))
projectName
  :: MonadWidget t m
  => Event t ()
  -> m (Event t (ReqResult () ProjectName))
(listEndpoint
  :<|> createEndpoint
  :<|> archiveEndpoint
  :<|> updateEndpoint
  :<|> infoEndpoint
  :<|> fullInfoEndpoint
  :<|> statusEndpoint
  :<|> restoreEndpoint)
  :<|> pingEndpoint
  :<|> projectName = apiClients

-- | Parser of kubectl command responses.
commandResponse
  :: ReqResult tag CommandResponse -- ^ Response of a kubectl request.
  -> Maybe CommandResponse
commandResponse = \case
  ResponseSuccess _ a _ -> Just a
  ResponseFailure _ _ xhr ->
    xhr ^? xhrResponse_response . _Just
      . to getArrayBufferBody . _Just
      . to decodeStrict . _Just
  RequestFailure _ _ -> Nothing
  where
    getArrayBufferBody = \case
      XhrResponseBody_ArrayBuffer x -> Just x
      _ -> Nothing

-- | Gets the websocket url path.
wsPath :: Text
wsPath = T.pack $ symbolVal (Proxy @ApiWSPath)

-- | Helper for event with request result.
processResp
  :: Reflex t
  => Event t (ReqResult tag a)
  -- ^ Event with a request result.
  -> (Event t a, Event t ())
  -- ^ (Success event with obtained data, failure event).
processResp respEv =
  let
    respOkEv = fmapMaybe reqSuccess respEv
    errEv = fmapMaybe reqFailure respEv
  in (respOkEv, () <$ errEv)
