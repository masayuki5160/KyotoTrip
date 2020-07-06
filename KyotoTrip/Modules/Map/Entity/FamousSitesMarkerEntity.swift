//
//  FamousSitesMarkerEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/07/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import CoreLocation

struct FamousSitesMarkerEntity: MarkerEntityProtocol {
    static var layerId = "kyoto-famous-sites"
    static var titleId = ""
    static var facebookURLKey = "sns_facebook"
    static var twitterURLKey = "sns_twitter"
    static var instagramURLKey = "sns_instagram"
    static var youtubeURLKey = "sns_youtube"
    static var urlKey = "url"
    static var categoryKey = "category"
    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: MarkerCategory = .famousSites
    var facebook = ""
    var twitter = ""
    var instagram = ""
    var youtube = ""
    var url = ""
    var siteCategpry = ""

    static func titleId(lang: LanguageSettings) -> String {
        switch lang {
        case .english: return "name_en"
        case .japanese: return "name_jp"
        }
    }
}
