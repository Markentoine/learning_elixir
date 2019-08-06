module Players
    exposing
        ( PresenceState
        , decodePresenceState
        , initialPresences
        , viewPlayers
        )

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder, field)


type alias PresenceState =
    Dict String (List PresenceMetaData)


type alias EncodedPresenceState =
    Dict String (List Decode.Value)


type alias PresenceMetaData =
    { color : String
    , online_at : String
    }


type alias PlayerPresence =
    { name : String
    , color : String
    , online_at : String
    , score : Int
    }


type alias Scores =
    Dict String Int


initialPresences : PresenceState
initialPresences =
    Dict.empty


decodePresenceState : EncodedPresenceState -> PresenceState
decodePresenceState payload =
    payload
        |> Dict.toList
        |> List.map decodePresences
        |> Dict.fromList



-- VIEW


viewPlayers : Scores -> PresenceState -> Html msg
viewPlayers scores presences =
    let
        playerPresences =
            toPlayerPresences scores presences
    in
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "Who's Playing" ]
        , div [ class "panel-body" ]
            [ ul [ id "players", class "list-group" ]
                (List.map viewPlayer playerPresences)
            ]
        ]


viewPlayer : PlayerPresence -> Html msg
viewPlayer player =
    li [ class "list-group-item" ]
        [ span
            [ class "player-color"
            , style [ ( "background-color", player.color ) ]
            ]
            [ text "" ]
        , span [ class "player-name" ] [ text player.name ]
        , span [ class "player-score" ] [ text (toString player.score) ]
        ]


toPlayerPresences : Scores -> PresenceState -> List PlayerPresence
toPlayerPresences scores presences =
    presences
        |> Dict.toList
        |> List.map (toPlayerPresence scores)


{-| Converts a player's first presence metadata to a `PlayerPresence`,
which includes the player's score fetched from the specified `scores`.
-}
toPlayerPresence : Scores -> ( String, List PresenceMetaData ) -> PlayerPresence
toPlayerPresence scores ( name, metas ) =
    case List.head metas of
        Just metaData ->
            let
                color =
                    metaData.color

                online_at =
                    metaData.online_at

                score =
                    Maybe.withDefault 0 (Dict.get name scores)
            in
            PlayerPresence name color online_at score

        Nothing ->
            PlayerPresence name "" "" 0



-- DECODERS


decodePresences : ( String, List Decode.Value ) -> ( String, List PresenceMetaData )
decodePresences ( name, encodedMetas ) =
    ( name, List.map decodeMetaData encodedMetas )


decodeMetaData : Decode.Value -> PresenceMetaData
decodeMetaData value =
    case Decode.decodeValue metaDataDecoder value of
        Ok presenceMetaData ->
            presenceMetaData

        Err err ->
            PresenceMetaData "" ""


metaDataDecoder : Decoder PresenceMetaData
metaDataDecoder =
    Decode.map2 PresenceMetaData
        (field "color" Decode.string)
        (field "online_at" Decode.string)
