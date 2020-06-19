//
//  RestaurantsRequestParamGatewayStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

@testable import KyotoTrip

class RestaurantsRequestParamGatewayStub: RestaurantsRequestParamGatewayProtocol {
    
    let result: Result<RestaurantsRequestParamEntity, RestaurantsRequestParamGatewayError>
    
    init(result: Result<RestaurantsRequestParamEntity, RestaurantsRequestParamGatewayError>) {
        self.result = result
    }
    
    func fetch(complition: (Result<RestaurantsRequestParamEntity, RestaurantsRequestParamGatewayError>) -> Void) {
        complition(result)
    }
    
    func save(entity: RestaurantsRequestParamEntity) {
    }
}
