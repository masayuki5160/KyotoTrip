//
//  RestaurantsSearchGatewayStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
@testable import KyotoTrip
import Foundation

struct RestaurantsSearchGatewayStub: RestaurantsSearchGatewayProtocol {
    func fetch(param: RestaurantsRequestParamEntity, complition: @escaping (Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void) {
        /// Set dummy data with json file
        let path = Bundle.main.path(forResource: "gnaviAPIDummyResponse", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)

        /// decode dummy json file
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let resultEntity = try! decoder.decode(RestaurantsSearchResultEntity.self, from: data)
        
        complition(.success(resultEntity))
    }
}
