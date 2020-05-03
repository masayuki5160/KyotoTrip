//
//  Feature.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/29.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

enum VisibleFeatureType {
    case Busstop
    case Event
    case RentalCycle
    case CulturalProperty
    case CycleParking
    case BusRoute
    case None
}

struct VisibleFeature {
    var title = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: VisibleFeatureType = .None
}
