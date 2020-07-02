//
//  FamousSitesMarkerViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/07/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

struct FamousSitesMarkerViewData: MarkerViewDataProtocol {
    var name: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    var type: MarkerCategory
    var detail: FamousSitesDetailViewData

    init(entity: FamousSitesMarkerEntity) {
        self.name = entity.title
        self.subtitle = entity.subtitle
        self.coordinate = entity.coordinate
        self.type = .culturalProperty
        self.detail = FamousSitesDetailViewData(
            name: entity.title
        )
    }
}
