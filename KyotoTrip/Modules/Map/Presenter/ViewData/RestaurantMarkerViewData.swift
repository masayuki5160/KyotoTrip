//
//  RestaurantMarkerViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

struct RestaurantMarkerViewData: MarkerViewDataProtocol {
    var name: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    var type: MarkerCategory
    var detail: RestaurantDetailViewData
    
    init(entity: RestaurantMarkerEntity) {
        self.name = entity.title
        self.subtitle = entity.subtitle
        self.coordinate = entity.coordinate
        self.type = .Restaurant
        
        let restaurantEntity = entity.detail!
        self.detail = RestaurantDetailViewData(
            name: restaurantEntity.name.name,
            nameKana: restaurantEntity.name.nameKana,
            address: restaurantEntity.contacts.address,
            access: restaurantEntity.access,
            tel: restaurantEntity.contacts.tel,
            businessHour: restaurantEntity.businessHour,
            holiday: restaurantEntity.holiday,
            salesPoint: restaurantEntity.salesPoints.prLong,
            url: restaurantEntity.url,
            imageUrl: restaurantEntity.imageUrl.thumbnail
        )
    }
}
