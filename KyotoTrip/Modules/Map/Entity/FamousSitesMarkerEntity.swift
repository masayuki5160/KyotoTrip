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
    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: MarkerCategory = .famousSites

    static func titleId(lang: LanguageSettings) -> String {
        switch lang {
        case .english: return "name_en"
        case .japanese: return "name_jp"
        }
    }
}
