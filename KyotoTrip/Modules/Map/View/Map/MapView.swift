//
//  KyotoMapView.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/25.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import Mapbox

class MapView: MGLMapView {
    static let kyotoStationLat = 34.9857083
    static let kyotoStationLong = 135.7560416
    static let defaultZoomLv = 13.0
    private let darkSytleURL = "mapbox://styles/masayuki5160/ckbwyma0h1l2e1in4j357f4ha"
    var busstopLayer: MGLStyleLayer?
    var busRouteLayer: MGLStyleLayer?
    var culturalPropertyLayer: MGLStyleLayer?
    var famousSitesLayer: MGLStyleLayer?

    func setup() {
        if #available(iOS 13, *), UITraitCollection.current.userInterfaceStyle == .dark {
            self.styleURL = URL(string: darkSytleURL)
        }

        self.setCenter(CLLocationCoordinate2D(latitude: MapView.kyotoStationLat, longitude: MapView.kyotoStationLong), zoomLevel: MapView.defaultZoomLv, animated: false)
        self.showsUserLocation = true
        self.compassView.compassVisibility = .visible
        self.compassViewPosition = .topLeft
    }
}
