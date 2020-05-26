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
    var busstopLayer: MGLStyleLayer?
    var busRouteLayer: MGLStyleLayer?
    var culturalPropertyLayer: MGLStyleLayer?
    var visibleMarkerCategory: MarkerCategory = .None
    
    func setup() {
        self.setCenter(CLLocationCoordinate2D(latitude: MapView.kyotoStationLat, longitude: MapView.kyotoStationLong), zoomLevel: MapView.defaultZoomLv, animated: false)
        self.showsUserLocation = true
        self.compassView.compassVisibility = .visible
        self.compassViewPosition = .topLeft
    }
}
