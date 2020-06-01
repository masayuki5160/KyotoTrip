//
//  CategoryCellViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/29.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct CategoryCellViewData {
    var title = ""
    var iconName = ""
    
    /// Need to know this when tapped cell, and then tell the detail to MapView to add the marker.
    var detail: MarkerEntityProtocol
}
