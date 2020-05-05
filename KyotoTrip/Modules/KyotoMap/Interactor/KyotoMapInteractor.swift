//
//  KyotoMapUseCase.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/10.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol KyotoMapInteractorProtocol: AnyObject {
    func updateCulturalPropertylayer(_ layer: VisibleLayer) -> VisibleLayer
    func updateBusstopLayer(_ layer: VisibleLayer) -> VisibleLayer
}

final class KyotoMapInteractor: KyotoMapInteractorProtocol {
    func updateCulturalPropertylayer(_ layer: VisibleLayer) -> VisibleLayer {
        let nextStatusRawValue = layer.culturalPropertyLayer.rawValue + 1
        let nextStatus = VisibleLayer.Status(rawValue: nextStatusRawValue) ?? VisibleLayer.Status.hidden
        let nextVisibleLayer = VisibleLayer(
            busstopLayer: layer.busstopLayer,
            culturalPropertyLayer: nextStatus,
            infoLayer: layer.infoLayer,
            rentalCycle: layer.rentalCycle,
            cycleParking: layer.cycleParking
        )

        return nextVisibleLayer
    }
    
    func updateBusstopLayer(_ layer: VisibleLayer) -> VisibleLayer {
        let nextStatusRawValue = layer.busstopLayer.rawValue + 1
        let nextStatus = VisibleLayer.Status(rawValue: nextStatusRawValue) ?? VisibleLayer.Status.hidden
        let nextVisibleLayer = VisibleLayer(
            busstopLayer: nextStatus,
            culturalPropertyLayer: layer.culturalPropertyLayer,
            infoLayer: layer.infoLayer,
            rentalCycle: layer.rentalCycle,
            cycleParking: layer.cycleParking
        )
        
        return nextVisibleLayer
    }
}
