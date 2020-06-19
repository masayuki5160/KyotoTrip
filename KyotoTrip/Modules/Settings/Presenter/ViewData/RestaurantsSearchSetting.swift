//
//  RestaurantsSearchSetting.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/08.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

enum RestaurantsSearchSetting: CaseIterable {
    case searchRange
    case englishSpeaker
    case koreanSpeaker
    case chaineseSpeaker
    case vegetarian
    case creditCard
    case privateRoom
    case wifi
    case noSmoking

    func toString() -> String {
        switch self {
        case .searchRange: return "RestaurantSearchSettingsPageSearchRange".localized
        case .englishSpeaker: return "RestaurantSearchSettingsPageEnglishSpeaker".localized
        case .koreanSpeaker: return "RestaurantSearchSettingsPageKoreanSpeaker".localized
        case .chaineseSpeaker: return "RestaurantSearchSettingsPageChineseSpeaker".localized
        case .vegetarian: return "RestaurantSearchSettingsPageVegetarian".localized
        case .creditCard: return "RestaurantSearchSettingsPageCreditCard".localized
        case .privateRoom: return "RestaurantSearchSettingsPagePrivateRoom".localized
        case .wifi: return "RestaurantSearchSettingsPageWifi".localized
        case .noSmoking: return "RestaurantSearchSettingsPageNoSmoking".localized
        }
    }
}
