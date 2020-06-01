//
//  MarkerViewDataProtocol.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import CoreLocation

protocol MarkerViewDataProtocol {
    var name: String { get }
    var subtitle: String { get }
    var coordinate: CLLocationCoordinate2D { get }
    var type: MarkerCategory { get }
}
