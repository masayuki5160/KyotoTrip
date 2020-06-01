//
//  RestaurantsRequestParamGatewayStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

@testable import KyotoTrip

class RestaurantsRequestParamGatewayStub: RestaurantsRequestParamGatewayProtocol {
    var settings = RestaurantsRequestParamEntity()
    func fetch(complition: (Result<RestaurantsRequestParamEntity, RestaurantsRequestParamGatewayError>) -> Void) {
        complition(.success(settings))
    }
    
    func save(entity: RestaurantsRequestParamEntity) {
        settings = entity
    }
}
