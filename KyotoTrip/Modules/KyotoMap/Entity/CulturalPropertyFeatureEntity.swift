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
struct CulturalPropertyFeatureEntity: VisibleFeatureProtocol {
    static var layerId = "kyoto-cultural-property"
    /// 文化財の名称
    static var titleId = "P32_006"
    /// 文化財の住所
    static var addressId = "P32_007"
    /// 文化財の種別に関する大分類区分コード
    static var largeClassificationCodeId = "P32_004"
    /// 文化財の種別に関する小分類区分コード
    static var smallClassificationCodeId = "P32_005"
    /// 指定文化財に指定された年月日
    static var registerdDateId = "P32_008"
    
    var title = ""
    var subtitle = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var type: VisibleFeatureCategory = .CulturalProperty
    var address = ""
    var largeClassificationCode = 0
    var smallClassificationCode = 0
    var registerdDate = 0
    
    var largeClassification: String {
        let res: String
        switch largeClassificationCode {
        case 1:
            res = "有形文化財"
        case 2:
            res = "無形文化財"
        case 3:
            res = "民俗文化財"
        case 4:
            res = "記念物"
        case 5:
            res = "文化的景観"
        case 6:
            res = "伝統的建造物群"
        case 7:
            res = "文化財の保存技術"
        default:
            res = ""
        }
        return res
    }
    
    var smallClassification: String {
        let res: String
        switch smallClassificationCode {
        case 11:
            res = "有形文化財"
        case 21:
            res = "無形文化財"
        case 31:
            res = "有形民俗文化財"
        case 32:
            res = "無形民俗文化財"
        case 41:
            res = "史跡（旧跡を含む）"
        case 42:
            res = "名勝"
        case 43:
            res = "天然記念物"
        case 51:
            res = "重要文化的景観"
        case 61:
            res = "伝統的建造物群保存地区"
        case 71:
            res = "選定保存技術"
        default:
            res = ""
        }
        return res
    }
    
    var registerDateString: String {
        let registerDateStr = String(registerdDate)
        let year = registerDateStr.prefix(4)
        let month = (registerDateStr.prefix(6)).suffix(2)
        let day = registerDateStr.suffix(2)
        return "\(year)/\(month)/\(day)"
    }
}
