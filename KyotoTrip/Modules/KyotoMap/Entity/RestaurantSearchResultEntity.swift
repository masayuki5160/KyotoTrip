//
//  RestaurantSearchResultEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

/// - Note:
///   Response from ForeignRestSearchAPI by Gurunavi
///    API details https://api.gnavi.co.jp/api/manual/foreignrestsearch/
struct RestaurantSearchResultEntity: Codable {
    var total_hit_count: Int = 0
    var hit_per_page: Int = 0
    var page_offset: Int = 0
    var rest: [RestaurantEntity] = []
    
    struct RestaurantEntity: Codable {
        var id: String = ""
        var name: NameEntity = NameEntity()
        var business_hour: String = ""
        var holiday: String = ""
        var contacts: ContactsEntity = ContactsEntity()
        var sales_points: SalesPointsEntity = SalesPointsEntity()
        var access: String = ""
        var budget: Int = 0
        var credit_card: String = ""
        var categories: CategoriesEntity = CategoriesEntity()
        var location: LocationEntity = LocationEntity()
        var url: String = ""
        var url_mobile: String = ""
        var image_url: ImageUrlEntity = ImageUrlEntity()
        
        struct NameEntity: Codable {
            var name: String = ""
            var name_kana: String = ""
        }
        struct ContactsEntity: Codable {
            var address: String = ""
            var tel: String = ""
        }
        struct SalesPointsEntity: Codable {
            var pr_short: String = ""
            var pr_long: String = ""
        }
        struct CategoriesEntity: Codable {
            var category: String = ""
            var category_name_l: [String] = []
            var category_name_s: [String] = []
        }
        struct LocationEntity: Codable {
            var latitude: String = ""
            var longitude: String = ""
            var latitude_wgs84: String = ""
            var longitude_wgs84: String = ""
            var area: AreaEntity = AreaEntity()
            
            struct AreaEntity: Codable {
                var district: String = ""
                var prefname: String = ""
                var areaname_s: String = ""
            }
        }
        struct ImageUrlEntity: Codable {
            var thumbnail: String = ""
            var qrcode: String = ""
        }
    }
}
