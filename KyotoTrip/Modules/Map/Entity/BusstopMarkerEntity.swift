//
//  BusstopMarkerEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

/// - Note:
///   Using Shapefile from MLIT(Ministry of Land, Infrastructure and Transport)
///    Japanese version http://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-P11.html
///    English version http://nlftp.mlit.go.jp/ksj-e/gml/datalist/KsjTmplt-P11.html
struct BusstopMarkerEntity: MarkerEntityProtocol {
    /// Style Layer ID defined at Mapbox Studio
    static var layerId = "kyoto-busstop"

    /// IDs defined in shapefile published by MLIT

    static var titleId = "P11_001"
    static var busCategoryId = "P11_002"
    static var organizationId = "P11_003_1"
    static var busRouteId = "P11_004_1"

    var title = ""
    var subtitle: String {
        var routeNameforSubtitle = "[路線] \(routes[0])"
        if routes.count > 1 {
            routeNameforSubtitle =
                routeNameforSubtitle + " 他"
        }

        return routeNameforSubtitle
    }
    public var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    public var type: MarkerCategory = .busstop
    public var routeNameString = ""
    public var organizationNameString = ""
    public var routes: [String] {
        routeNameString.components(separatedBy: ",")
    }
    public var organizations: [String] {
        organizationNameString.components(separatedBy: ",")
    }
}
