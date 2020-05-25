//
//  BusstopMarkerEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

/// - Note:
///   Using Shapefile from MLIT(Ministry of Land, Infrastructure and Transport)
///    Japanese version http://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-P11.html
///    English version http://nlftp.mlit.go.jp/ksj-e/gml/datalist/KsjTmplt-P11.html
struct BusstopMarkerEntity: MarkerEntityProtocol {
    static var layerId = "kyoto-busstop"
    
    /// バス停名
    static var titleId = "P11_001"
    /// バス区分
    static var busCategoryId = "P11_002"
    /// P11_003_1～19    バス路線情報_事業者名
    static var organizationId = ""
    /// P11_004_1～19    バス路線情報_バス系統
    static var busRouteCategoryId = ""
    
    
    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: MarkerCategory = .Busstop
}
