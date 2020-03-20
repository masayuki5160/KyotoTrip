//
//  MapViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    
    let kyotoStationLat = 34.9857083
    let kyotoStationLong = 135.7560416
    let defaultZoomLv = 13.0
    let mbxStyleURL = "mapbox://styles/mapbox/streets-v11"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NavigationBarTitleMap".localized
        
        let url = URL(string: mbxStyleURL)
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: kyotoStationLat, longitude: kyotoStationLong), zoomLevel: defaultZoomLv, animated: false)
        view.addSubview(mapView)
    }
    
}
