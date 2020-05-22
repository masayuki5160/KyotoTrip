//
//  AppSettingsInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol AppSettingsInteractorProtocol: AnyObject {
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void)
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity)
}

final class AppSettingsInteractor: AppSettingsInteractorProtocol {
    
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
