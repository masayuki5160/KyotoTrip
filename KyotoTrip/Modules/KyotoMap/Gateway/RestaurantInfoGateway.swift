//
//  RestaurantInfoGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Alamofire

protocol RestaurantInfoGatewayProtocol: AnyObject {
    func fetch(complition: @escaping (Result<RestaurantSearchResultEntity>) -> Void)
}

class RestaurantInfoGateway: RestaurantInfoGatewayProtocol {
    
    // TODO: accessTokenの管理方法を修正
    private let accessToken = "78a33f7ad28955fdaccc7c99e7ef6dc3"
    private var url: String {
        return "https://api.gnavi.co.jp/ForeignRestSearchAPI/v3/?keyid=\(accessToken)&pref=PREF26"
    }

    init() {
    }
    
    func fetch(complition: @escaping (Result<RestaurantSearchResultEntity>) -> Void) {
        Alamofire.request(url).responseJSON { response in
            if response.error != nil {
                complition(.failure(response.error!))
                return
            }
            
            let decodedJson = try! JSONDecoder().decode(RestaurantSearchResultEntity.self, from: response.data!)
            complition(.success(decodedJson))
        }
    }
}
