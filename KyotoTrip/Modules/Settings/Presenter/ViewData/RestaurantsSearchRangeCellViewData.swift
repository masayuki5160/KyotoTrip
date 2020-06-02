//
//  restaurantsSearchRangeRowEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/22.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct RestaurantsSearchRangeCellViewData {
    typealias SearchRange = RestaurantsRequestSearchRange
    
    var range: SearchRange = .range300
    var isSelected = false
    var rangeString: String {
        return range.toString()
    }

}
