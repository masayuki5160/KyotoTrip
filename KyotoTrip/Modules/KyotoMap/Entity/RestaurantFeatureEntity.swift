//
//  RestaurantFeatureEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

struct RestaurantFeatureEntity: VisibleFeatureProtocol {
    static var layerId = ""
    static var titleId = ""
    
    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: VisibleFeatureCategory = .Restaurant
    
    // TODO: 飲食店用の情報追記
}
