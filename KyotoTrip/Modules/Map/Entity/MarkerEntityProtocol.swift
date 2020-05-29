//
//  MarkerEntityProtocol.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

/// Note
/// There are several approaches that can be used to add markers.
/// MarkerEntityProtocol is entity protocol for both using style layer and annotations.
/// More details: https://docs.mapbox.com/ios/maps/overview/markers-and-annotations/
protocol MarkerEntityProtocol {
    static var layerId: String { get }
    static var titleId: String { get }
    var title: String { get }
    var subtitle: String { get }
    var coordinate: CLLocationCoordinate2D { get }
    var type: MarkerCategory { get }
}
