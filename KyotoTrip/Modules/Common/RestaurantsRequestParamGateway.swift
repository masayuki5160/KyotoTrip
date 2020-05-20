//
//  RestaurantsRequestParamGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/20.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation

protocol RestaurantsRequestParamGatewayProtocol {
    func fetch() -> RestaurantsRequestParamEntity
    func save(entity: RestaurantsRequestParamEntity)
}

class RestaurantsRequestParamGateway: RestaurantsRequestParamGatewayProtocol {
    private let userdefaultsKey = "RestaurantsRequestParam"
    
    func fetch() -> RestaurantsRequestParamEntity {
        guard let data = UserDefaults.standard.data(forKey: userdefaultsKey) else {
            return RestaurantsRequestParamEntity()
        }

        do {
            let decodedData = try JSONDecoder().decode(RestaurantsRequestParamEntity.self, from: data)
            return decodedData
        } catch let error {
            print(error)
            return RestaurantsRequestParamEntity()
        }
    }
    
    func save(entity: RestaurantsRequestParamEntity) {
        do {
            let encodedData = try JSONEncoder().encode(entity)
            UserDefaults.standard.set(encodedData, forKey: userdefaultsKey)
        } catch let error {
            print(error)
        }
    }
}
