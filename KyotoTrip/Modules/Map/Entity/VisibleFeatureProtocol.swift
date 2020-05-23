//
//  VisibleFeatureProtocol.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

protocol VisibleFeatureProtocol {
    static var layerId: String { get }
    static var titleId: String { get }
    var title: String { get }
    var subtitle: String { get }
    var coordinate: CLLocationCoordinate2D { get }
    var type: VisibleFeatureCategory { get }
}
