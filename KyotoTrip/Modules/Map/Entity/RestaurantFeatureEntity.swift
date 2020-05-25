//
//  RestaurantFeatureEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

struct RestaurantMarkerEntity: MarkerEntityProtocol {
    static var layerId = ""
    static var titleId = ""
    
    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: MarkerCategory = .Restaurant
    var detail: RestaurantEntity? = nil
}
