//
//  RestaurantsRequestSearchRange.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/02.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

enum RestaurantsRequestSearchRange: Int, Codable {
    case range300 = 1
    case range500
    case range1000
    case range2000
    case range3000

    func toString() -> String {
        switch self {
        case .range300:  return "300m"
        case .range500:  return "500m"
        case .range1000: return "1000m"
        case .range2000: return "2000m"
        case .range3000: return "3000m"
        }
    }
}
