//
//  AppSettingsInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol AppSettingsInteractorProtocol: AnyObject {
    func uiSwitchStatusToRequestFlg(_ status: Bool) -> RestaurantsRequestParamEntity.RequestFilterFlg
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
}
