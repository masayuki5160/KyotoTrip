//
//  AppSettingsInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol SettingsInteractorProtocol: AnyObject {
    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void)
    func fetchLanguageSetting(complition: (Result<LanguageSettings, LanguageSettingGatewayError>) -> Void)
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity)
    func saveLanguageSetting(setting: LanguageSettings)
}

class SettingsInteractor: SettingsInteractorProtocol {
    struct Dependency {
        let restaurantsRequestParamGateway: RestaurantsRequestParamGatewayProtocol
        let languageSettingGateway: LanguageSettingGatewayProtocol
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func fetchRestaurantsRequestParam(complition: (RestaurantsRequestParamEntity) -> Void) {
        dependency.restaurantsRequestParamGateway.fetch { response in
            switch response {
            case .failure(_):

                // Return default settings when failed fetching data
                complition(RestaurantsRequestParamEntity())

            case .success(let entity):
                complition(entity)
            }
        }
    }

    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity) {
        dependency.restaurantsRequestParamGateway.save(entity: entity)
    }

    func fetchLanguageSetting(complition: (Result<LanguageSettings, LanguageSettingGatewayError>) -> Void) {
        dependency.languageSettingGateway.fetch { response in
            switch response {
            case .success(let setting):
                complition(.success(setting))
            case .failure(_):
                // TODO: fix later
                complition(.success(LanguageSettings.japanese))
            }
        }
    }

    func saveLanguageSetting(setting: LanguageSettings) {
        dependency.languageSettingGateway.save(setting: setting)
    }
}
