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
}
