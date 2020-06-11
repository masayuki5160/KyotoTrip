//
//  MapCenterPosition.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

enum MapCenterPosition: Int {
    case kyotoCity = 0
    case userLocation

    func next() -> Self {
        switch self {
        case .kyotoCity: return .userLocation
        case .userLocation: return .kyotoCity
        }
    }
}
