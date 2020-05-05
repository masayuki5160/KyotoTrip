//
//  VisibleLayer.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct VisibleLayer {
    enum Status: Int {
        case hidden = 0
        case visible
    }
    
    let busstop: Status
    let culturalProperty: Status
    let info: Status
    let rentalCycle: Status
    let cycleParking: Status
}
