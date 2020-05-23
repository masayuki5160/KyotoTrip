//
//  RestaurantsSearchSettingsInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol RestaurantsSearchSettingsInteractorProtocol {
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void)
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity)
}

class RestaurantsSearchSettingsInteractor: RestaurantsSearchSettingsInteractorProtocol {
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void) {
        RestaurantsRequestParamGateway().fetch { response in
            switch response {
            case .failure(_):
                complition(RestaurantsRequestParamEntity())
            case .success(let entity):
                complition(entity)
            }
        }
    }
    
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity) {
        RestaurantsRequestParamGateway().save(entity: entity)
    }
}
