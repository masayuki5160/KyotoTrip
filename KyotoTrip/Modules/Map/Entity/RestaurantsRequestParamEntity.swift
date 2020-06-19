//
//  RestaurantInfoRequestParamEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/11.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct RestaurantsRequestParamEntity: Codable {
    enum RequestFilterFlg: Int, Codable {
        case off = 0
        case on

        func nextStatus() -> RequestFilterFlg {
            switch self {
            case .off: return .on
            case .on: return .off
            }
        }
    }
    enum Language: String, Codable {
        case japanese = "ja" // Japanese
        case zhCn = "zh_cn" // Chinese (簡体字)
        case zhTw = "zh_tw" // Chinese (繁体字)
        case korean = "ko" // Korean
        case english = "en" // English
    }

    var latitude = ""
    var longitude = ""
    var language: LanguageSettings = .japanese
    var langSettingRequestParam: Language {
        switch language {
        case .japanese: return .japanese
        case .english: return .english
        }
    }
    var range: RestaurantsRequestSearchRange = .range500
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
}
