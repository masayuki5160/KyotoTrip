//
//  RestaurantInfoRequestParamEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/11.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation

struct RestaurantsRequestParamEntity {
    enum SearchRange: Int {
        case range300 = 1
        case range500
        case range1000
        case range2000
        case range3000
    }
    enum RequestFilterFlg: Int {
        case off = 0
        case on
    }
    
    var latitude = ""
    var longitude = ""
    var range: SearchRange = .range500
    var rangeStr: String {
        switch range {
        case .range300:
            return "300m"
        case .range500:
            return "500m"
        case .range1000:
            return "1000m"
        case .range2000:
            return "2000m"
        case .range3000:
            return "3000m"
        }
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
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            UserDefaults.standard.set(archiveData, forKey: userdefaultsKey)

        } catch {
            fatalError("Archive failed")
        }
    }

    func load() -> RestaurantsRequestParamEntity {
        let param = UserDefaults.standard.object(forKey: userdefaultsKey) as? RestaurantsRequestParamEntity ?? RestaurantsRequestParamEntity()
        return param
    }
}
