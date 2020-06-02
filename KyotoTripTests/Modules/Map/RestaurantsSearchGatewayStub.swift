//
//  RestaurantsSearchGatewayStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
@testable import KyotoTrip
import Foundation

class RestaurantsSearchGatewayStub: RestaurantsSearchGatewayProtocol {
    private var result: Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>
    
    init(result: Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) {
        self.result = result
    }

    func fetch(param: RestaurantsRequestParamEntity, complition: @escaping (Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void) {
        complition(result)
    }
}
