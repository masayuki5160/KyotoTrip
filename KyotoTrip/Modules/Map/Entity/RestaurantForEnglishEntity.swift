//
//  RestaurantForEnglishEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct RestaurantForEnglishEntity: Codable {
    var id: String = ""
    var name: NameEntity
    var businessHour: String = ""
    var holiday: String = ""
    var contacts: ContactsEntity
    var salesPoints: SalesPointsEntity
    var access: String = ""
    var budget: Int = 0
    var creditCard: String = ""
    var categories: CategoriesEntity
    var location: LocationEntity
    var url: String = ""
    var urlMobile: String = ""
    var imageUrl: ImageUrlEntity

    struct NameEntity: Codable {
        var name: String = ""
        var nameSub: String = ""
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
        var categoryNameL: [String] = []
        var categoryNameS: [String] = []
    }
    struct LocationEntity: Codable {
        var latitude: String = ""
        var longitude: String = ""
        var latitudeWgs84: String = ""
        var longitudeWgs84: String = ""
        var area: AreaEntity

        // swiftlint:disable nesting
        struct AreaEntity: Codable {
            var district: String = ""
            var prefname: String = ""
            var areanameS: String = ""
            var areanameL: String = ""
        }
    }
    struct ImageUrlEntity: Codable {
        var thumbnail: String = ""
    }

    func convertToRestaurntEntity() -> RestaurantEntity {
        RestaurantEntity(
            id: self.id,
            name: .init(name: self.name.name, nameKana: ""),
            businessHour: self.businessHour,
            holiday: self.holiday,
            contacts: .init(address: self.contacts.address, tel: self.contacts.address),
            salesPoints: .init(prShort: self.salesPoints.prShort, prLong: self.salesPoints.prShort),
            access: self.access,
            budget: self.budget,
            creditCard: self.creditCard,
            categories: .init(category: "", categoryNameL: self.categories.categoryNameL, categoryNameS: self.categories.categoryNameS),
            location: .init(
                latitude: self.location.latitude,
                longitude: self.location.longitude,
                latitudeWgs84: self.location.latitudeWgs84,
                longitudeWgs84: self.location.longitudeWgs84,
                area: .init(
                    district: self.location.area.district,
                    prefname: self.location.area.prefname,
                    areanameS: self.location.area.areanameS
                )
            ),
            url: self.url,
            urlMobile: self.urlMobile,
            imageUrl: .init(thumbnail: self.imageUrl.thumbnail, qrcode: "")
        )
    }
}
