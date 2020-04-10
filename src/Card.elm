module Card exposing (Card(..), toString, value, svg, top, decoder, encode)

import Html exposing (img, Html)
import Html.Attributes exposing (src)
import Json.Decode as Decode
import Json.Encode as Encode

type Card
    = OneClubs Int
    | TwoClubs Int
    | ThreeClubs Int
    | FourClubs Int
    | FiveClubs Int
    | SixClubs Int
    | SevenClubs Int
    | HeightClubs Int
    | NineClubs Int
    | TenClubs Int
    | ValetClubs Int
    | ReineClubs Int
    | RoiClubs Int
      -- Diamond
    | OneDiamond Int
    | TwoDiamond Int
    | ThreeDiamond Int
    | FourDiamond Int
    | FiveDiamond Int
    | SixDiamond Int
    | SevenDiamond Int
    | HeightDiamond Int
    | NineDiamond Int
    | TenDiamond Int
    | ValetDiamond Int
    | ReineDiamond Int
    | RoiDiamond Int
      -- Hearts
    | OneHearts Int
    | TwoHearts Int
    | ThreeHearts Int
    | FourHearts Int
    | FiveHearts Int
    | SixHearts Int
    | SevenHearts Int
    | HeightHearts Int
    | NineHearts Int
    | TenHearts Int
    | ValetHearts Int
    | ReineHearts Int
    | RoiHearts Int
      -- Spades
    | OneSpades Int
    | TwoSpades Int
    | ThreeSpades Int
    | FourSpades Int
    | FiveSpades Int
    | SixSpades Int
    | SevenSpades Int
    | HeightSpades Int
    | NineSpades Int
    | TenSpades Int
    | ValetSpades Int
    | ReineSpades Int
    | RoiSpades Int


value : Card -> Int
value card = 
    case card of 
        OneClubs a -> 
            a

        TwoClubs a -> 
            a

        ThreeClubs a -> 
            a

        FourClubs a -> 
            a

        FiveClubs a -> 
            a

        SixClubs a -> 
            a

        SevenClubs a -> 
            a

        HeightClubs a -> 
            a

        NineClubs a -> 
            a

        TenClubs a -> 
            a

        ValetClubs a -> 
            a

        ReineClubs a -> 
            a

        RoiClubs a -> 
            a

        OneDiamond a -> 
            a

        TwoDiamond a -> 
            a

        ThreeDiamond a -> 
            a

        FourDiamond a -> 
            a

        FiveDiamond a -> 
            a

        SixDiamond a -> 
            a

        SevenDiamond a -> 
            a

        HeightDiamond a -> 
            a

        NineDiamond a -> 
            a

        TenDiamond a -> 
            a

        ValetDiamond a -> 
            a

        ReineDiamond a -> 
            a

        RoiDiamond a -> 
            a

        OneHearts a -> 
            a

        TwoHearts a -> 
            a

        ThreeHearts a -> 
            a

        FourHearts a -> 
            a

        FiveHearts a -> 
            a

        SixHearts a -> 
            a

        SevenHearts a -> 
            a

        HeightHearts a -> 
            a

        NineHearts a -> 
            a

        TenHearts a -> 
            a

        ValetHearts a -> 
            a

        ReineHearts a -> 
            a

        RoiHearts a -> 
            a

        OneSpades a -> 
            a

        TwoSpades a -> 
            a

        ThreeSpades a -> 
            a

        FourSpades a -> 
            a

        FiveSpades a -> 
            a

        SixSpades a -> 
            a

        SevenSpades a -> 
            a

        HeightSpades a -> 
            a

        NineSpades a -> 
            a

        TenSpades a -> 
            a

        ValetSpades a -> 
            a

        ReineSpades a -> 
            a

        RoiSpades a -> 
            a

top : Card -> Html msg
top card = 
    case card of 
        OneClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        TwoClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        ThreeClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        FourClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        FiveClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        SixClubs _ -> 
          img [ src "./assets/1B.svg" ] []

        SevenClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        HeightClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        NineClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        TenClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        ValetClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        ReineClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        RoiClubs _ -> 
           img [ src "./assets/1B.svg" ] []

        OneSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        TwoSpades _ -> 
           img [ src "./assets/1B.svg" ] []

        ThreeSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        FourSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        FiveSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        SixSpades _ -> 
           img [ src "./assets/1B.svg" ] []

        SevenSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        HeightSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        NineSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        TenSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        ValetSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        ReineSpades _ -> 
           img [ src  "./assets/1B.svg" ] []

        RoiSpades _ -> 
           img [ src  "./assets/1B.svg" ] []
        _ -> 
            img [ src  "./assets/2B.svg" ] []

svg : Card -> Html msg
svg card = 
    case card of 
        OneClubs _ -> 
           img [ src "./assets/AC.svg" ] []

        TwoClubs _ -> 
           img [ src "./assets/2C.svg" ] []

        ThreeClubs _ -> 
           img [ src "./assets/3C.svg" ] []

        FourClubs _ -> 
           img [ src "./assets/4C.svg" ] []

        FiveClubs _ -> 
           img [ src "./assets/5C.svg" ] []

        SixClubs _ -> 
           img [ src "./assets/6C.svg" ] []

        SevenClubs _ -> 
           img [ src "./assets/7C.svg" ] []

        HeightClubs _ -> 
           img [ src "./assets/8C.svg" ] []

        NineClubs _ -> 
           img [ src "./assets/9C.svg" ] []

        TenClubs _ -> 
           img [ src "./assets/TC.svg" ] []

        ValetClubs _ -> 
           img [ src "./assets/JC.svg" ] []

        ReineClubs _ -> 
           img [ src "./assets/QC.svg" ] []

        RoiClubs _ -> 
           img [ src "./assets/KC.svg" ] []

        OneDiamond _ -> 
           img [ src "./assets/AD.svg" ] []

        TwoDiamond _ -> 
           img [ src "./assets/2D.svg" ] []

        ThreeDiamond _ -> 
           img [ src "./assets/3D.svg" ] []

        FourDiamond _ -> 
           img [ src "./assets/4D.svg" ] []

        FiveDiamond _ -> 
           img [ src "./assets/5D.svg" ] []

        SixDiamond _ -> 
           img [ src "./assets/6D.svg" ] []

        SevenDiamond _ -> 
           img [ src "./assets/7D.svg" ] []

        HeightDiamond _ -> 
           img [ src "./assets/8D.svg" ] []

        NineDiamond _ -> 
           img [ src "./assets/9D.svg" ] []

        TenDiamond _ -> 
           img [ src "./assets/TD.svg" ] []

        ValetDiamond _ -> 
           img [ src "./assets/JD.svg" ] []

        ReineDiamond _ -> 
           img [ src "./assets/QD.svg" ] []

        RoiDiamond _ -> 
           img [ src "./assets/KD.svg" ] []

        OneHearts _ -> 
           img [ src "./assets/AH.svg" ] []

        TwoHearts _ -> 
           img [ src "./assets/2H.svg" ] []

        ThreeHearts _ -> 
           img [ src "./assets/3H.svg" ] []

        FourHearts _ -> 
           img [ src "./assets/4H.svg" ] []

        FiveHearts _ -> 
           img [ src "./assets/5H.svg" ] []

        SixHearts _ -> 
           img [ src "./assets/6H.svg" ] []

        SevenHearts _ -> 
           img [ src "./assets/7H.svg" ] []

        HeightHearts _ -> 
           img [ src "./assets/8H.svg" ] []

        NineHearts _ -> 
           img [ src "./assets/9H.svg" ] []

        TenHearts _ -> 
           img [ src "./assets/TH.svg" ] []

        ValetHearts _ -> 
           img [ src "./assets/JH.svg" ] []

        ReineHearts _ -> 
           img [ src "./assets/QH.svg" ] []

        RoiHearts _ -> 
           img [ src "./assets/KH.svg" ] []

        OneSpades _ -> 
           img [ src "./assets/AS.svg" ] []

        TwoSpades _ -> 
           img [ src "./assets/2S.svg" ] []

        ThreeSpades _ -> 
           img [ src "./assets/3S.svg" ] []

        FourSpades _ -> 
           img [ src "./assets/4S.svg" ] []

        FiveSpades _ -> 
           img [ src "./assets/5S.svg" ] []

        SixSpades _ -> 
           img [ src "./assets/6S.svg" ] []

        SevenSpades _ -> 
           img [ src "./assets/7S.svg" ] []

        HeightSpades _ -> 
           img [ src "./assets/8S.svg" ] []

        NineSpades _ -> 
           img [ src "./assets/9S.svg" ] []

        TenSpades _ -> 
           img [ src "./assets/TS.svg" ] []

        ValetSpades _ -> 
           img [ src "./assets/JS.svg" ] []

        ReineSpades _ -> 
           img [ src "./assets/QS.svg" ] []

        RoiSpades _ -> 
           img [ src "./assets/KS.svg" ] []
toString : Card  -> String
toString n =
    case n of
        OneClubs _ ->
            "One Clubs"

        TwoClubs _ ->
            "Two Clubs"

        ThreeClubs _ ->
            "Three Clubs"

        FourClubs _ ->
            "Four Clubs"

        FiveClubs _ ->
            "Five Clubs"

        SixClubs _ ->
            "Six Clubs"

        SevenClubs _ ->
            "Seven Clubs"

        HeightClubs _ ->
            "Height Clubs"

        NineClubs _ ->
            "Nine Clubs"

        TenClubs _ ->
            "Ten Clubs"

        ValetClubs _ ->
            "Valet Clubs"

        ReineClubs _ ->
            "Reine Clubs"

        RoiClubs _ ->
            "Roi Clubs"

        OneDiamond _ ->
            "One Diamond"

        TwoDiamond _ ->
            "Two Diamond"

        ThreeDiamond _ ->
            "Three Diamond"

        FourDiamond _ ->
            "Four Diamond"

        FiveDiamond _ ->
            "Five Diamond"

        SixDiamond _ ->
            "Six Diamond"

        SevenDiamond _ ->
            "Seven Diamond"

        HeightDiamond _ ->
            "Height Diamond"

        NineDiamond _ ->
            "Nine Diamond"

        TenDiamond _ ->
            "Ten Diamond"

        ValetDiamond _ ->
            "Valet Diamond"

        ReineDiamond _ ->
            "Reine Diamond"

        RoiDiamond _ ->
            "Roi Diamond"

        OneHearts _ ->
            "One Hearts"

        TwoHearts _ ->
            "Two Hearts"

        ThreeHearts _ ->
            "Three Hearts"

        FourHearts _ ->
            "Four Hearts"

        FiveHearts _ ->
            "Five Hearts"

        SixHearts _ ->
            "Six Hearts"

        SevenHearts _ ->
            "Seven Hearts"

        HeightHearts _ ->
            "Height Hearts"

        NineHearts _ ->
            "Nine Hearts"

        TenHearts _ ->
            "Ten Hearts"

        ValetHearts _ ->
            "Valet Hearts"

        ReineHearts _ ->
            "Reine Hearts"

        RoiHearts _ ->
            "Roi Hearts"

        OneSpades _ ->
            "One Spades"

        TwoSpades _ ->
            "Two Spades"

        ThreeSpades _ ->
            "Three Spades"

        FourSpades _ ->
            "Four Spades"

        FiveSpades _ ->
            "Five Spades"

        SixSpades _ ->
            "Six Spades"

        SevenSpades _ ->
            "Seven Spades"

        HeightSpades _ ->
            "Height Spades"

        NineSpades _ ->
            "Nine Spades"

        TenSpades _ ->
            "Ten Spades"

        ValetSpades _ ->
            "Valet Spades"

        ReineSpades _ ->
            "Reine Spades"

        RoiSpades _ ->
            "Roi Spades"

encode: Card -> Encode.Value
encode card = 
    Encode.object [
        ("card", Encode.string (toString card))
        , ("value", Encode.int (value card) )
    ]
decoder: Decode.Decoder Card
decoder  = 
    Decode.field "card" Decode.string 
        |> Decode.andThen (\card -> 
            case card of
                "One Clubs" -> 
                    Decode.map OneClubs (Decode.field "value" Decode.int)
                "Two Clubs" -> 
                    Decode.map TwoClubs (Decode.field "value" Decode.int)
                "Three Clubs" -> 
                    Decode.map ThreeClubs (Decode.field "value" Decode.int)
                "Four Clubs" -> 
                    Decode.map FourClubs (Decode.field "value" Decode.int)
                "Five Clubs" -> 
                    Decode.map FiveClubs (Decode.field "value" Decode.int)
                "Six Clubs" -> 
                    Decode.map SixClubs (Decode.field "value" Decode.int)
                "Seven Clubs" -> 
                    Decode.map SevenClubs (Decode.field "value" Decode.int)
                "Height Clubs" -> 
                    Decode.map HeightClubs (Decode.field "value" Decode.int)
                "Nine Clubs" -> 
                    Decode.map NineClubs (Decode.field "value" Decode.int)
                "Ten Clubs" -> 
                    Decode.map TenClubs (Decode.field "value" Decode.int)
                "Valet Clubs" -> 
                    Decode.map ValetClubs (Decode.field "value" Decode.int)
                "Reine Clubs" -> 
                    Decode.map ReineClubs (Decode.field "value" Decode.int)
                "Roi Clubs" -> 
                    Decode.map RoiClubs (Decode.field "value" Decode.int)
                -- Diamond
                "One Diamond" -> 
                    Decode.map OneDiamond (Decode.field "value" Decode.int)
                "Two Diamond" -> 
                    Decode.map TwoDiamond (Decode.field "value" Decode.int)
                "Three Diamond" -> 
                    Decode.map ThreeDiamond (Decode.field "value" Decode.int)
                "Four Diamond" -> 
                    Decode.map FourDiamond (Decode.field "value" Decode.int)
                "Five Diamond" -> 
                    Decode.map FiveDiamond (Decode.field "value" Decode.int)
                "Six Diamond" -> 
                    Decode.map SixDiamond (Decode.field "value" Decode.int)
                "Seven Diamond" -> 
                    Decode.map SevenDiamond (Decode.field "value" Decode.int)
                "Height Diamond" -> 
                    Decode.map HeightDiamond (Decode.field "value" Decode.int)
                "Nine Diamond" -> 
                    Decode.map NineDiamond (Decode.field "value" Decode.int)
                "Ten Diamond" -> 
                    Decode.map TenDiamond (Decode.field "value" Decode.int)
                "Valet Diamond" -> 
                    Decode.map ValetDiamond (Decode.field "value" Decode.int)
                "Reine Diamond" -> 
                    Decode.map ReineDiamond (Decode.field "value" Decode.int)
                "Roi Diamond" -> 
                    Decode.map RoiDiamond (Decode.field "value" Decode.int)

                -- Hearts
                "One Hearts" -> 
                    Decode.map OneHearts (Decode.field "value" Decode.int)
                "Two Hearts" -> 
                    Decode.map TwoHearts (Decode.field "value" Decode.int)
                "Three Hearts" -> 
                    Decode.map ThreeHearts (Decode.field "value" Decode.int)
                "Four Hearts" -> 
                    Decode.map FourHearts (Decode.field "value" Decode.int)
                "Five Hearts" -> 
                    Decode.map FiveHearts (Decode.field "value" Decode.int)
                "Six Hearts" -> 
                    Decode.map SixHearts (Decode.field "value" Decode.int)
                "Seven Hearts" -> 
                    Decode.map SevenHearts (Decode.field "value" Decode.int)
                "Height Hearts" -> 
                    Decode.map HeightHearts (Decode.field "value" Decode.int)
                "Nine Hearts" -> 
                    Decode.map NineHearts (Decode.field "value" Decode.int)
                "Ten Hearts" -> 
                    Decode.map TenHearts (Decode.field "value" Decode.int)
                "Valet Hearts" -> 
                    Decode.map ValetHearts (Decode.field "value" Decode.int)
                "Reine Hearts" -> 
                    Decode.map ReineHearts (Decode.field "value" Decode.int)
                "Roi Hearts" -> 
                    Decode.map RoiHearts (Decode.field "value" Decode.int)
                -- Spades
                "One Spades" -> 
                    Decode.map OneSpades (Decode.field "value" Decode.int)
                "Two Spades" -> 
                    Decode.map TwoSpades (Decode.field "value" Decode.int)
                "Three Spades" -> 
                    Decode.map ThreeSpades (Decode.field "value" Decode.int)
                "Four Spades" -> 
                    Decode.map FourSpades (Decode.field "value" Decode.int)
                "Five Spades" -> 
                    Decode.map FiveSpades (Decode.field "value" Decode.int)
                "Six Spades" -> 
                    Decode.map SixSpades (Decode.field "value" Decode.int)
                "Seven Spades" -> 
                    Decode.map SevenSpades (Decode.field "value" Decode.int)
                "Height Spades" -> 
                    Decode.map HeightSpades (Decode.field "value" Decode.int)
                "Nine Spades" -> 
                    Decode.map NineSpades (Decode.field "value" Decode.int)
                "Ten Spades" -> 
                    Decode.map TenSpades (Decode.field "value" Decode.int)
                "Valet Spades" -> 
                    Decode.map ValetSpades (Decode.field "value" Decode.int)
                "Reine Spades" -> 
                    Decode.map ReineSpades (Decode.field "value" Decode.int)
                "Roi Spades" -> 
                    Decode.map RoiSpades (Decode.field "value" Decode.int)
                _ -> 
                    Decode.fail ("Invalide card" ++ card)
        )