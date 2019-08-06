module Bingo exposing (..)

import Chat
import Dict exposing (Dict)
import Game
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder, field)
import Json.Encode as Encode
import Phoenix
import Phoenix.Channel exposing (Channel)
import Phoenix.Push
import Phoenix.Presence
import Phoenix.Socket exposing (Socket)
import Players


-- MODEL


type alias Model =
    { channelTopic : String
    , phxSocket : Socket Msg
    , gameSummary : Game.GameSummary
    , chatMessageInput : String
    , chatMessages : List Chat.ChatMessage
    , presences : Players.PresenceState
    , error : Maybe String
    }


initialModel : String -> Socket Msg -> Model
initialModel channelTopic socket =
    { channelTopic = channelTopic
    , phxSocket = socket
    , gameSummary = Game.initialSummary
    , chatMessageInput = ""
    , chatMessages = []
    , presences = Players.initialPresences
    , error = Nothing
    }



-- UPDATE


type Msg
    = NoOp
    | ReceiveGameSummary Decode.Value
    | SendMark String
    | SetChatMessageInput String
    | SendChatMessage
    | ReceiveChatMessage Decode.Value
    | ReceivePresence (Dict String (List Decode.Value))
    | ReceiveError Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ReceiveGameSummary payload ->
            case Game.decodeGameSummary payload of
                Ok gameSummary ->
                    ( { model | gameSummary = gameSummary }, Cmd.none )

                Err error ->
                    ( setError error model, Cmd.none )

        SendMark phrase ->
            let
                payload =
                    Encode.object [ ( "phrase", Encode.string phrase ) ]

                pushMsg =
                    Phoenix.Push.init model.channelTopic "mark_square" 
                        |> Phoenix.Push.withPayload payload
                        |> Phoenix.Push.onError ReceiveError

                pushCmd =
                  Phoenix.push model.phxSocket.endpoint pushMsg
            in
            ( model, pushCmd)

        SetChatMessageInput message ->
            ( { model | chatMessageInput = message }, Cmd.none )

        SendChatMessage ->
            let
                payload =
                    Chat.encodeChatMessage model.chatMessageInput

                pushMsg =
                    Phoenix.Push.init model.channelTopic "new_chat_message"
                        |> Phoenix.Push.withPayload payload
                        |> Phoenix.Push.onError ReceiveError

                pushCmd =
                  Phoenix.push model.phxSocket.endpoint pushMsg
            in
            ( { model | chatMessageInput = "" }, pushCmd)

        ReceiveChatMessage payload ->
            case Chat.decodeChatMessage payload of
                Ok message ->
                    ( { model | chatMessages = message :: model.chatMessages }
                    , Chat.scrollToMessage NoOp
                    )

                Err error ->
                    ( setError error model, Cmd.none )

        ReceivePresence presenceState ->
            let
                presences = 
                    Players.decodePresenceState presenceState
            in
            ( { model | presences = presences }, Cmd.none )

        ReceiveError payload ->
            case Decode.decodeValue errorDecoder payload of
                Ok message ->
                    ( { model | error = Just message }, Cmd.none )

                Err error ->
                    ( setError error model, Cmd.none )


setError : String -> Model -> Model
setError error model =
    { model | error = Just (toString error) }


errorDecoder : Decoder String
errorDecoder =
    field "reason" Decode.string



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ viewErrorMaybe model
        , viewBingo model
        ]


viewErrorMaybe : Model -> Html Msg
viewErrorMaybe model =
    case model.error of
        Just message ->
            p [ class "alert alert-danger" ]
                [ text message ]

        Nothing ->
            text ""


viewBingo : Model -> Html Msg
viewBingo model =
    div [ class "row" ]
        [ div [ class "col-xs-8" ]
            [ Game.viewGame SendMark model.gameSummary ]
        , div [ class "col-xs-4" ]
            [ Players.viewPlayers
                model.gameSummary.scores
                model.presences
            , Chat.viewChatMessages
                model.chatMessages
            , Chat.viewChatMessageForm
                SendChatMessage
                SetChatMessageInput
                model.chatMessageInput
            ]
        ]



-- SUBSCRIPTIONS


{-| Listens for messages. 
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.connect model.phxSocket [ initPhoenixChannel model.channelTopic ]



-- PHOENIX SOCKET AND CHANNEL INITIALIZATION


initPhoenixSocket : String -> String -> Socket Msg
initPhoenixSocket socketUrl token =
    Phoenix.Socket.init socketUrl
        |> Phoenix.Socket.withParams [ ( "token", token ) ]


initPhoenixChannel : String -> Channel Msg
initPhoenixChannel topic =
    let
        presence =
            Phoenix.Presence.create
                |> Phoenix.Presence.onChange ReceivePresence
    in
    Phoenix.Channel.init topic
        |> Phoenix.Channel.on "game_summary" ReceiveGameSummary
        |> Phoenix.Channel.on "new_chat_message" ReceiveChatMessage
        |> Phoenix.Channel.withPresence presence
        |> Phoenix.Channel.onJoinError ReceiveError
        |> Phoenix.Channel.withDebug


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        channelTopic =
            "games:" ++ flags.gameName

        socket =
            initPhoenixSocket flags.wsUrl flags.authToken

        model =
            initialModel channelTopic socket
    in
    ( model, Cmd.none )


-- MAIN


type alias Flags =
    { gameName : String
    , authToken : String
    , wsUrl : String
    }


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
