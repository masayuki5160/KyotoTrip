//
//  RestaurantInfoGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Alamofire

protocol RestaurantsSearchGatewayProtocol: AnyObject {
    func fetch(param: RestaurantsRequestParamEntity, complition: @escaping (Swift.Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void)
}

enum RestaurantsSearchResponseError: Error {
    case entryNotFound
    case otherError(detail: String)
}

/// - Note:
///   ForeignRestSearchAPI
///   request parameter details https://api.gnavi.co.jp/api/manual/foreignrestsearch/
class RestaurantsSearchGateway: RestaurantsSearchGatewayProtocol {
    // TODO: Access token is too open. Use more secure ways.
    private var accessToken = "78a33f7ad28955fdaccc7c99e7ef6dc3"
    private var targetPrefecture = "PREF26"// Set Kyoto prefecture code
    
    func fetch(param: RestaurantsRequestParamEntity, complition: @escaping (Swift.Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void) {
        let url = buildUrl(param)
        Alamofire.request(url).responseJSON { response in
            if response.error != nil {
                let errorDetail = response.error!.localizedDescription
                complition(.failure(RestaurantsSearchResponseError.otherError(detail: errorDetail)))
                return
            }
            
            switch response.response?.statusCode {
            case 404:// 検索結果の件数が0
                complition(.failure(RestaurantsSearchResponseError.entryNotFound))
            case 200:// 検索結果の件数が1以上
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let resultEntity = try decoder.decode(RestaurantsSearchResultEntity.self, from: response.data!)
                    complition(.success(resultEntity))
                } catch let error {
                    let errorDetail = error.localizedDescription
                    complition(.failure(RestaurantsSearchResponseError.otherError(detail: errorDetail)))
                }
            default:
                let errorDetail = "Unknown Error"
                complition(.failure(RestaurantsSearchResponseError.otherError(detail: errorDetail)))
                break
            }
        }
    }
    
    private func buildUrl(_ param: RestaurantsRequestParamEntity) -> String {
        let urlStr = "https://api.gnavi.co.jp/ForeignRestSearchAPI/v3/?"
            + "keyid=\(accessToken)&pref=\(targetPrefecture)"
            + "&latitude=\(param.latitude)&longitude=\(param.longitude)"
            + "&range=\(param.range.rawValue)&hit_per_page=\(param.hitPerPage)"
            + "&english_speaking_staff=\(param.englishSpeakingStaff.rawValue)"
            + "&english_menu=\(param.englishMenu.rawValue)"
            + "&korean_speaking_staff=\(param.koreanSpeakingStaff.rawValue)"
            + "&korean_menu=\(param.koreanMenu.rawValue)"
            + "&chinese_speaking_staff=\(param.chineseSpeakingStaff.rawValue)"
            + "&simplified_chinese_menu=\(param.simplifiedChineseMenu.rawValue)"
            + "&traditional_chinese_menu=\(param.traditionalChineseMenu.rawValue)"
            + "&vegetarian_menu_options=\(param.vegetarianMenuOptions.rawValue)"
            + "&religious_menu_options=\(param.religiousMenuOptions.rawValue)"
            + "&wifi=\(param.wifi.rawValue)&card=\(param.card.rawValue)"
            + "&private_room=\(param.privateRoom.rawValue)&no_smoking=\(param.noSmoking.rawValue)"

        return urlStr
    }
}
