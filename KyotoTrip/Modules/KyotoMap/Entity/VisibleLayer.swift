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
    
    init() {
        busstop = .hidden
        culturalProperty = .hidden
        info = .hidden
        rentalCycle = .hidden
        cycleParking = .hidden
    }
    
    init(busstop: Status, culturalProperty: Status, info: Status, rentalCycle: Status, cycleParking: Status) {
        self.busstop = busstop
        self.culturalProperty = culturalProperty
        self.info = info
        self.rentalCycle = rentalCycle
        self.cycleParking = cycleParking
    }
}
