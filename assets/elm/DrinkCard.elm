module DrinkCard exposing (drinkCard)

import Html exposing (..)
import Html.Attributes exposing (..)
import SharedTypes exposing (Drink)


drinkCard : Int -> Drink -> Html msg
drinkCard index d =
    div [ class "ph2-ns w-90 w-third-m w-25-l center-s" ]
        [ div
            [ class "shadow-4 br2 tr pb3 mv3 relative" ]
            [ label [ for <| "display-back-" ++ String.fromInt index, class "pointer" ]
                [ div [ class "card-front-contents" ]
                    [ div [ class "bb b--cs-light-pink bw3 mb3 tl h-25rem h-27rem-l" ]
                        [ h4 [ class "f4 lh4 pa3 shadow-4 br2 mt4 mb1 tc bg-sheer-white absolute-horizontal-center top-1 w-80" ] [ text <| d.brand ++ " " ++ d.name ]
                        , img [ src d.image, alt "Photo of drink", class "min-w-5rem max-h-16rem db center pt4" ] []
                        , p [ class "bg-cs-mint br2 ph3 pv2 white shadow-4 ml4 mv4 dib" ] [ text <| String.fromFloat d.abv ++ "% ABV" ]
                        ]
                    ]
                , input [ type_ "checkbox", name "card-front", id <| "display-back-" ++ String.fromInt index, class "display-back dn" ] []
                , label [ for <| "display-back-" ++ String.fromInt index, class "cs-mid-blue f6 lh6 tr pr4 underline pointer" ] []
                , div [ class "card-back-contents dn absolute top-0 left-0 bg-white pt3 ph3 w-100" ]
                    [ div [ class "tl h-23rem h-25rem-l overflow-y-auto" ]
                        [ div [ class "bb b--pink mt2 mh2 pb3 center" ]
                            [ h4 [ class "f4 lh4 mb1" ] [ text d.name ]
                            , p [ class "f5 lh5 mv1" ] [ text "by" ]
                            , a [ class "f4 lh4 cs-mid-blue mv1", href <| "/brands/" ++ d.brandSlug ] [ text d.brand ] -- this line. d.brand link
                            ]
                        , div [ class "flex flex-wrap" ]
                            [ p [ class "w-50 pv2 dib" ]
                                [ text <|
                                    case List.head d.drink_types of
                                        Just t ->
                                            t

                                        Nothing ->
                                            ""
                                ]
                            , p [ class "w-50 pv2 dib tr" ]
                                [ text <|
                                    case List.head d.drink_styles of
                                        Just t ->
                                            t

                                        Nothing ->
                                            ""
                                ]
                            , p [ class "dib bg-cs-mint br2 ph3 pv2 white shadow-4 mv2" ] [ text <| String.fromFloat d.abv ++ "% ABV" ]
                            ]
                        , p [ class "pv2 f6 lh6 wrap", style "white-space" "pre-wrap" ]
                            [ text d.description
                            ]
                        ]
                    ]
                ]
            ]
        ]
