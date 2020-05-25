//
//  RestaurantEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct RestaurantEntity: Codable {
    var id: String = ""
    var name: NameEntity = NameEntity()
    var businessHour: String = ""
    var holiday: String = ""
    var contacts: ContactsEntity = ContactsEntity()
    var salesPoints: SalesPointsEntity = SalesPointsEntity()
    var access: String = ""
    var budget: Int = 0
    var creditCard: String = ""
    var categories: CategoriesEntity = CategoriesEntity()
    var location: LocationEntity = LocationEntity()
    var url: String = ""
    var urlMobile: String = ""
    var imageUrl: ImageUrlEntity = ImageUrlEntity()
    
    struct NameEntity: Codable {
        var name: String = ""
        var nameKana: String = ""
    }
    struct ContactsEntity: Codable {
        var address: String = ""
        var tel: String = ""
    }
    struct SalesPointsEntity: Codable {
        var prShort: String = ""
        var prLong: String = ""
    }
    struct CategoriesEntity: Codable {
        var category: String = ""
        var categoryNameL: [String] = []
        var categoryNameS: [String] = []
    }
    struct LocationEntity: Codable {
        var latitude: String = ""
        var longitude: String = ""
        var latitudeWgs84: String = ""
        var longitudeWgs84: String = ""
        var area: AreaEntity = AreaEntity()
        
        struct AreaEntity: Codable {
            var district: String = ""
            var prefname: String = ""
            var areanameS: String = ""
        }
    }
    struct ImageUrlEntity: Codable {
        var thumbnail: String = ""
        var qrcode: String = ""
    }
}
