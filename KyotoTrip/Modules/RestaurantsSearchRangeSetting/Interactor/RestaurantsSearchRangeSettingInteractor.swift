//
//  RestaurantsSearchRangeInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol RestaurantsSearchRangeSettingInteractorProtocol {
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void)
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity)
}

class RestaurantsSearchRangeSettingInteractor: RestaurantsSearchRangeSettingInteractorProtocol {
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void) {
        RestaurantsRequestParamGateway().fetch { response in
            switch response {
            case .failure(_):
                /// Return default settings when failed fetching data
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
