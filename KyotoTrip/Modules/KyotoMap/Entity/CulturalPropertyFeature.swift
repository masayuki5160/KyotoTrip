//
//  CulturalPropertyFeature.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

/// - Note:
///   Using Shapefile from MLIT(Ministry of Land, Infrastructure and Transport)
///    Japanese version http://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-P32.html
///    English version http://nlftp.mlit.go.jp/ksj-e/gml/datalist/KsjTmplt-P32.html
struct CulturalPropertyFeature: VisibleFeatureProtocol {
    /// 文化財の名称
    static var titleId = "P32_006"
    /// 文化財の住所
    static var address = "P32_007"
    
    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: VisibleFeatureCategory = .CulturalProperty
}
