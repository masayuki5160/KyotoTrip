//
//  CategoryCellViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/29.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct CategoryCellViewData {
    let busstopIconName = "icons8-bus-80"
    let restaurantIconName = "icons8-restaurant-100"
    let culturalPropertyIconName = "icons8-torii-48"

    var title = ""
    /// Need to know this when tapped cell, and then tell the detail to MapView to add the marker.
    var viewData: MarkerViewDataProtocol
    var iconName: String {
        let iconName: String
        switch viewData.type {
        case .busstop:
            iconName = busstopIconName

        case .culturalProperty:
            iconName = culturalPropertyIconName

        case .restaurant:
            iconName = restaurantIconName

        default:
            // TODO: Set default icon name
            iconName = busstopIconName
        }

        return iconName
    }
        
    init(entity: MarkerEntityProtocol) {
        self.title = entity.title

        switch entity.type {
        case .busstop:
            // swiftlint:disable force_cast
            self.viewData = BusstopMarkerViewData(entity: entity as! BusstopMarkerEntity)

        case .culturalProperty:
            // swiftlint:disable force_cast
            self.viewData = CulturalPropertyMarkerViewData(entity: entity as! CulturalPropertyMarkerEntity)

        case .restaurant:
            // swiftlint:disable force_cast
            self.viewData = RestaurantMarkerViewData(entity: entity as! RestaurantMarkerEntity)

        default:
            // swiftlint:disable force_cast
            self.viewData = BusstopMarkerViewData(entity: entity as! BusstopMarkerEntity)
        }
    }
}
