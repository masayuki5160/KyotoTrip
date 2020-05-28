//
//  CategoryCellViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct CategoryCellViewData {
    var title = ""
    var iconName = ""
    
    // No need to use this for CategoryViewController.
    // Store MarkerEntity, and pass through to CategoryPresenter when tapped cell.
    var markerEntity: MarkerEntityProtocol
}
