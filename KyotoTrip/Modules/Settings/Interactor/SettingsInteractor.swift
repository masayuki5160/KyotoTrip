//
//  AppSettingsInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol SettingsInteractorProtocol: AnyObject {
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void)
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity)
}

final class SettingsInteractor: SettingsInteractorProtocol {
    
    struct Dependency {
        let restaurantsRequestParamGateway: RestaurantsRequestParamGatewayProtocol
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void) {
        dependency.restaurantsRequestParamGateway.fetch { response in
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
        dependency.restaurantsRequestParamGateway.save(entity: entity)
    }
}
