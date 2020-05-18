//
//  RestaurantInfoRequestParamEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/11.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation

struct RestaurantsRequestParamEntity: Codable {
    enum SearchRange: String, Codable {
        case range300 = "300m"
        case range500 = "500m"
        case range1000 = "1000m"
        case range2000 = "2000m"
        case range3000 = "3000m"
    }
    enum RequestFilterFlg: Int, Codable {
        case off = 0
        case on
    }
    
    var latitude = ""
    var longitude = ""
    var range: SearchRange = .range500
    var rangeStr: String {
        return range.rawValue
    }
    var hitPerPage = 20
    var englishSpeakingStaff: RequestFilterFlg = .off
    var englishMenu: RequestFilterFlg = .off
    var koreanSpeakingStaff: RequestFilterFlg = .off
    var koreanMenu: RequestFilterFlg = .off
    var chineseSpeakingStaff: RequestFilterFlg = .off
    var simplifiedChineseMenu: RequestFilterFlg = .off
    var traditionalChineseMenu: RequestFilterFlg = .off
    var vegetarianMenuOptions: RequestFilterFlg = .off
    var religiousMenuOptions: RequestFilterFlg = .off
    var wifi: RequestFilterFlg = .off
    var card: RequestFilterFlg = .off
    var privateRoom: RequestFilterFlg = .off
    var noSmoking: RequestFilterFlg = .off
    private let userdefaultsKey = "RestaurantsRequestParam"

    func save() {
        do {
            let encodedData = try JSONEncoder().encode(self)
            UserDefaults.standard.set(encodedData, forKey: userdefaultsKey)
        } catch {
            fatalError("Encode failed")
        }
    }

    func load() -> RestaurantsRequestParamEntity {
        guard let data = UserDefaults.standard.data(forKey: userdefaultsKey) else {
            return RestaurantsRequestParamEntity()
        }

        do {
            let decodedData = try JSONDecoder().decode(RestaurantsRequestParamEntity.self, from: data)
            return decodedData
        } catch {
            fatalError("Decode failed")
        }
    }
}
