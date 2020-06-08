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
        case .searchRange: return "検索範囲"
        case .englishSpeaker: return "英語スタッフ"
        case .koreanSpeaker: return "韓国語スタッフ"
        case .chaineseSpeaker: return "中国語スタッフ"
        case .vegetarian: return "ベジタリアンメニュー"
        case .creditCard: return "クレジットカード"
        case .privateRoom: return "個室"
        case .wifi: return "Wifi"
        case .noSmoking: return "禁煙"
        }
    }
}
