//
//  BusstopMarkerViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import CoreLocation

struct BusstopMarkerViewData: MarkerViewDataProtocol {
    var name: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    var type: MarkerCategory
    var detail: BusstopDetailViewData

    init(entity: BusstopMarkerEntity) {
        self.name = entity.title
        self.subtitle = entity.subtitle
        self.coordinate = entity.coordinate
        self.type = .busstop
        self.detail = BusstopDetailViewData(
            name: entity.title,
            routes: entity.routes,
            organizations: entity.organizations
        )
    }
}
