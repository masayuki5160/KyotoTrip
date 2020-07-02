//
//  CategoryButtonsStatusViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct CategoryButtonsStatusViewData {
    var busstop: CategoryButtonStatus
    var culturalProperty: CategoryButtonStatus
    var restaurant: CategoryButtonStatus
    var famousSites: CategoryButtonStatus

    init() {
        busstop = .hidden
        culturalProperty = .hidden
        restaurant = .hidden
        famousSites = .hidden
    }
}
