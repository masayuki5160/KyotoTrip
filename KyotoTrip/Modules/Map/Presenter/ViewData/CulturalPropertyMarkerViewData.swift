//
//  CulturalPropertyMarkerViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

struct CulturalPropertyMarkerViewData: MarkerViewDataProtocol {
    var name: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    var type: MarkerCategory
    var detail: CulturalPropertyDetailViewData

    init(entity: CulturalPropertyMarkerEntity) {
        self.name = entity.title
        self.subtitle = entity.subtitle
        self.coordinate = entity.coordinate
        self.type = .culturalProperty
        self.detail = CulturalPropertyDetailViewData(
            name: entity.title,
            address: entity.address,
            largeClassification: entity.largeClassification,
            smallClassification: entity.smallClassification,
            registerdDate: entity.registerDateString
        )
    }
}
