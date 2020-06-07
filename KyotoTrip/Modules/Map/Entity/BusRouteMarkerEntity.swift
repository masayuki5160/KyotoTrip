//
//  BusRouteMarkerEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

/// - Note:
///   Using Shapefile from MLIT(Ministry of Land, Infrastructure and Transport)
///    Japanese version http://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-N07.html
///    English version http://nlftp.mlit.go.jp/ksj-e/gml/datalist/KsjTmplt-N07.html
struct BusRouteMarkerEntity: MarkerEntityProtocol {
    static var layerId = "kyoto-bus-route"
    /// バス区分
    static var titleId = "N07_001"
    /// バス路線を運営する事業者名
    static var organizationId = "N07_002"
    /// バス路線の系統番号・系統名
    static var busRouteCategoryId = "N07_003"
    /// 平日の一日当たりの運行本数の平均値（本／日）
    static var weekdayId = "N07_004"
    /// 土曜日の一日の運行本数の平均値（本／日）
    static var saturdayId = "N07_005"
    /// 日曜日、祝日の一日の運行本数の平均値（本／日）
    static var sundayId = "N07_006"
    /// 備考
    static var noteId = "N07_007"

    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: MarkerCategory = .busRoute
}
