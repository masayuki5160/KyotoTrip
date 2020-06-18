//
//  RestaurantsRequestParamGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/20.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation

protocol RestaurantsRequestParamGatewayProtocol {
    func fetch(complition: (Result<RestaurantsRequestParamEntity, RestaurantsRequestParamGatewayError>) -> Void)
    func save(entity: RestaurantsRequestParamEntity)
    func initSettings()
}

enum RestaurantsRequestParamGatewayError: Error {
    case entryNotFound
    case decodeError
}

struct RestaurantsRequestParamGateway: RestaurantsRequestParamGatewayProtocol {
    private let userdefaultsKey = "RestaurantsRequestParam"

    func fetch(complition: (Result<RestaurantsRequestParamEntity, RestaurantsRequestParamGatewayError>) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: userdefaultsKey) else {
            complition(.failure(.entryNotFound))
            return
        }

        do {
            let decodedData = try JSONDecoder().decode(RestaurantsRequestParamEntity.self, from: data)
            complition(.success(decodedData))
        } catch _ {
            complition(.failure(.decodeError))
        }
    }

    func save(entity: RestaurantsRequestParamEntity) {
        do {
            let encodedData = try JSONEncoder().encode(entity)
            UserDefaults.standard.set(encodedData, forKey: userdefaultsKey)
        } catch {
            // TODO: Fix Later
        }
    }

    func initSettings() {
        let defaultSettings = RestaurantsRequestParamEntity()
        save(entity: defaultSettings)
    }
}
