namespace GeoToolkit

open System
open FSharpPlus
open GeoAPI
open NetTopologySuite
open ProjNet

type Transforms() =
    static let precisionModel =
        Geometries.PrecisionModels.Floating
        |> Geometries.PrecisionModel

    static let factory_wgs84 =
        CoordinateSystems.GeographicCoordinateSystem.WGS84.AuthorityCode
        |> Convert.ToInt32
        |> curry Geometries.GeometryFactory precisionModel

    static let factory_target =
        (50, true)
        |> CoordinateSystems.ProjectedCoordinateSystem.WGS84_UTM
        |> fun x -> x.AuthorityCode
        |> Convert.ToInt32
        |> curry Geometries.GeometryFactory precisionModel

    static let transformation =
        (50, true)
        |> CoordinateSystems.ProjectedCoordinateSystem.WGS84_UTM
        |> curry (CoordinateSystems.Transformations.CoordinateTransformationFactory().CreateFromCoordinateSystems)
            CoordinateSystems.GeographicCoordinateSystem.WGS84

    static member Wgs84ToUtm (origin: float * float) : Geometries.Point =
        let P =
            origin
            |> Geometries.Coordinate
            |> factory_wgs84.CreatePoint

        [|P.X; P.Y|]
        |> transformation.MathTransform.Transform
        |> fun x -> curry Geometries.Coordinate x.[0] x.[1]
        |> factory_target.CreatePoint

module GeoToolkit =
    [<EntryPoint>]
    let main (argv: string[]) : int =
        0