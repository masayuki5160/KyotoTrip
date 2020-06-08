//
//  RestaurantMarkerEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

/// Note
/// RestaurantMarkerEntity is for adding  restaurant markers using Annotations, not using style layers.
/// That's why no need to define layerId.
struct RestaurantMarkerEntity: MarkerEntityProtocol {
    static var layerId = ""
    static var titleId = ""

    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: MarkerCategory = .restaurant
    var detail: RestaurantEntity?
}
