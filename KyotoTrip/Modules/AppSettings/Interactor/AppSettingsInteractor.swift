//
//  AppSettingsInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol AppSettingsInteractorProtocol: AnyObject {
    func uiSwitchStatusToRequestFlg(_ status: Bool) -> RestaurantsRequestParamEntity.RequestFilterFlg
    func fetchRestaurantsRequestParam() -> RestaurantsRequestParamEntity
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity)
}

final class AppSettingsInteractor: AppSettingsInteractorProtocol {
    func uiSwitchStatusToRequestFlg(_ status: Bool) -> RestaurantsRequestParamEntity.RequestFilterFlg {
        let res: RestaurantsRequestParamEntity.RequestFilterFlg
        if status {
            res = RestaurantsRequestParamEntity.RequestFilterFlg.on
        } else {
            res = RestaurantsRequestParamEntity.RequestFilterFlg.off
        }

        return res
    }
    
    func fetchRestaurantsRequestParam() -> RestaurantsRequestParamEntity {
        let gateway = RestaurantsRequestParamGateway()
        return gateway.fetch()
    }
    
    func saveRestaurantsRequestParam(entity: RestaurantsRequestParamEntity) {
        let gateway = RestaurantsRequestParamGateway()
        gateway.save(entity: entity)
    }
}
