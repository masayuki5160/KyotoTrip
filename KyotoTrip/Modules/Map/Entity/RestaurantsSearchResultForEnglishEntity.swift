//
//  RestaurantsSearchResultForEnglishEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

/// - Note:
///   Response from ForeignRestSearchAPI by Gurunavi
///    API details https://api.gnavi.co.jp/api/manual/foreignrestsearch/
struct RestaurantsSearchResultForEnglishEntity: Codable {
    var totalHitCount: Int = 0
    var hitPerPage: Int = 0
    var pageOffset: Int = 0
    var rest: [RestaurantForEnglishEntity] = []
}
