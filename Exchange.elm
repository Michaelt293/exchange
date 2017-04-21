module Hello exposing (..)

import Html exposing (Html, Attribute, beginnerProgram, text, div, input, h1)
import Html.Events exposing (onInput)
import Html.Attributes exposing (class, placeholder, style)
import String
import FormatNumber exposing (..)


audToTwd : Float -> Float
audToTwd d =
    d * 22.8658


audToJpy : Float -> Float
audToJpy d =
    d * 82.0102


twdToAud : Float -> Float
twdToAud d =
    d / 22.8658


twdToJpy : Float -> Float
twdToJpy d =
    d * 3.59


jpyToAud : Float -> Float
jpyToAud d =
    d / 82.0102


jpyToTwd : Float -> Float
jpyToTwd d =
    d / 3.59


type alias Model =
    { audToTwd : Float
    , audToJpy : Float
    , twdToAud : Float
    , twdToJpy : Float
    , jpyToAud : Float
    , jpyToTwd : Float
    }


type Msg
    = Aud String
    | Twd String
    | Jpy String


update : Msg -> Model -> Model
update amount model =
    case amount of
        Aud v ->
            { model
                | audToTwd = updateHelper audToTwd v
                , audToJpy = updateHelper audToJpy v
            }

        Twd v ->
            { model
                | twdToAud = updateHelper twdToAud v
                , twdToJpy = updateHelper twdToJpy v
            }

        Jpy v ->
            { model
                | jpyToAud = updateHelper jpyToAud v
                , jpyToTwd = updateHelper jpyToTwd v
            }


updateHelper : (Float -> a) -> String -> a
updateHelper f =
    f << Result.withDefault 0 << String.toFloat


view : Model -> Html Msg
view model =
    div []
        [ h1 [ header ] [ text "匯率換算 ＥＸＣＨＡＮＧＥ - 澳幣 日幣 台幣" ]
        , div [ useStyle ] [ text "Enter AUD" ]
        , input [ placeholder "金額", onInput Aud, useStyle ] []
        , div [ useStyle ] [ text (formatCurrency model.audToTwd ++ "元") ]
        , div [ useStyle ] [ text (formatCurrency model.audToJpy ++ "円") ]
        , div [ useStyle ] [ text "Enter TWD" ]
        , input [ placeholder "金額", onInput Twd, useStyle ] []
        , div [ useStyle ] [ text ("$" ++ formatCurrency model.twdToAud) ]
        , div [ useStyle ] [ text (formatCurrency model.twdToJpy ++ "円") ]
        , div [ useStyle ] [ text "Enter JPY" ]
        , input [ placeholder "金額", onInput Jpy, useStyle ] []
        , div [ useStyle ] [ text ("$" ++ formatCurrency model.jpyToAud) ]
        , div [ useStyle ] [ text (formatCurrency model.jpyToTwd ++ "元") ]
        ]


formatCurrency : Float -> String
formatCurrency v =
    if v == 0 then
        formatFloat (Locale 0 "," ".") v
    else
        formatFloat (Locale 2 "," ".") v


useStyle : Attribute msg
useStyle =
    style
        [ ( "width", "20%" )
        , ( "height", "40px" )
        , ( "padding", "10px 0" )
        , ( "font-size", "2em" )
        , ( "text-align", "center" )
        ]


header : Attribute msg
header =
    style
        [ ( "width", "100%" )
        , ( "height", "50px" )
        , ( "padding", "10px 0" )
        , ( "font-size", "3em" )
        , ( "text-align", "center" )
        ]


main : Program Never Model Msg
main =
    beginnerProgram
        { model =
            { audToTwd = 0.0
            , twdToAud = 0.0
            , twdToJpy = 0.0
            , audToJpy = 0.0
            , jpyToAud = 0.0
            , jpyToTwd = 0.0
            }
        , view = view
        , update = update
        }
