//
//  MGLFeatureMediator.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Mapbox.MGLFeature

protocol MGLFeatureMediatorProtocol {
    /// Input from MapView
    func updateVisibleMGLFeatures(mglFeatures: [MGLFeature])

    /// Others
    func convertMGLFeatureToAnnotation(source: MGLFeature) -> CustomMGLPointAnnotation
    func sorteMGLFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature]
}

class MGLFeatureMediator: MGLFeatureMediatorProtocol {
    struct Dependency {
        let presenter: MapPresenter
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    public func updateVisibleMGLFeatures(mglFeatures: [MGLFeature]) {
        let markers = mglFeatures.map { feature -> MarkerEntityProtocol in
            convertMGLFeatureToMarkerEntity(source: feature)
        }

        dependency.presenter.updateVisibleMarkers(markers)
    }

    public func sorteMGLFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature] {
        features.sorted(
            by: {
                let distanceFromLocationA =
                    CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                        .distance(from: center)
                let distanceFromLocationB =
                    CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude)
                        .distance(from: center)

                return distanceFromLocationA < distanceFromLocationB
            }
        )
    }

    public func convertMGLFeatureToAnnotation(source: MGLFeature) -> CustomMGLPointAnnotation {
        let markerEntity = convertMGLFeatureToMarkerEntity(source: source)
        let markerViewData: MarkerViewDataProtocol
        switch markerEntity.type {
        case .busstop:
            // swiftlint:disable force_cast
            markerViewData = BusstopMarkerViewData(entity: markerEntity as! BusstopMarkerEntity)

        case .culturalProperty:
            // swiftlint:disable force_cast
            markerViewData = CulturalPropertyMarkerViewData(entity: markerEntity as! CulturalPropertyMarkerEntity)

        case .restaurant:
            // swiftlint:disable force_cast
            markerViewData = RestaurantMarkerViewData(entity: markerEntity as! RestaurantMarkerEntity)

        default:
            // swiftlint:disable force_cast
            markerViewData = BusstopMarkerViewData(entity: markerEntity as! BusstopMarkerEntity)
        }

        return CustomMGLPointAnnotation(viewData: markerViewData)
    }
}

private extension MGLFeatureMediator {
    private func convertMGLFeatureToMarkerEntity(source: MGLFeature) -> MarkerEntityProtocol {
        let category: MarkerCategory
        if source.attribute(forKey: BusstopMarkerEntity.titleId) != nil {
            category = .busstop
        } else if (source.attribute(forKey: CulturalPropertyMarkerEntity.titleId)) != nil {
            category = .culturalProperty
        } else {
            // Fix me later
            category = .busstop
        }

        switch category {
        case .busstop:
            return BusstopMarkerEntity(
                title: source.attributes[BusstopMarkerEntity.titleId] as! String,
                coordinate: source.coordinate,
                routeNameString: source.attributes[BusstopMarkerEntity.busRouteId] as! String,
                organizationNameString: source.attributes[BusstopMarkerEntity.organizationId] as! String
            )

        case .culturalProperty:
            return CulturalPropertyMarkerEntity(
                title: source.attributes[CulturalPropertyMarkerEntity.titleId] as! String,
                coordinate: source.coordinate,
                address: source.attributes[CulturalPropertyMarkerEntity.addressId] as! String,
                largeClassificationCode: source.attributes[CulturalPropertyMarkerEntity.largeClassificationCodeId] as! Int,
                smallClassificationCode: source.attributes[CulturalPropertyMarkerEntity.smallClassificationCodeId] as! Int,
                registerdDate: source.attributes[CulturalPropertyMarkerEntity.registerdDateId] as! Int
            )

        default:
            // TODO: Fix later
            return BusstopMarkerEntity(title: "", coordinate: source.coordinate)
        }
    }
}
