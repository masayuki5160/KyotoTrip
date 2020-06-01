//
//  UserPosition.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

enum UserPosition: Int {
    case kyotoCity = 0
    case currentLocation
    
    func next() -> Self {
        switch self {
        case .kyotoCity: return .currentLocation
        case .currentLocation: return .kyotoCity
        }
    }
}
