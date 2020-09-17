//
//  MapPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/21.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxCocoa
import RxSwift
import CoreLocation

struct MapViewInput {
    let compassButtonTapEvent: Driver<Void>
}

protocol MapPresenterProtocol: AnyObject {
    // MARK: - Properties

    static var layerIdentifiers: Set<String> { get }

    // MARK: - Input to Presenter from MapView

    func bindMapView(input: MapViewInput)
    func updateViewpoint(centerCoordinate: CLLocationCoordinate2D)
    func updateVisibleMarkers(_ markers: [MarkerEntityProtocol])
    func tapOnCallout(viewData: MarkerViewDataProtocol)

    // MARK: - Output from Presenter for MapView

    var mapCenterPositionDriver: Driver<MapCenterPosition>! { get }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> { get }
    var categoryButtonsStatusDriver: Driver<CategoryButtonsStatusViewData> { get }
    var restaurantMarkersDriver: Driver<[CustomMGLPointAnnotation]> { get }
    func fetchLanguageSetting(complition: (LanguageSettings) -> Void)
}

class MapPresenter: MapPresenterProtocol {
    // MARK: - Properties
    struct Dependency {
        let interactor: MapInteractorProtocol
        let router: MapRouterProtocol
    }

    static var layerIdentifiers: Set<String> = [
        BusstopMarkerEntity.layerId,
        CulturalPropertyMarkerEntity.layerId,
        FamousSitesMarkerEntity.layerId
    ]

    var mapCenterPositionDriver: Driver<MapCenterPosition>!
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> {
        dependency.interactor.selectedCategoryViewCellSignal
    }
    var categoryButtonsStatusDriver: Driver<CategoryButtonsStatusViewData>
    var restaurantMarkersDriver: Driver<[CustomMGLPointAnnotation]>

    private var dependency: Dependency
    private let disposeBag = DisposeBag()
    private var mapCenterPosition: MapCenterPosition = .kyotoCity

    // MARK: - Public functions

    init(dependency: Dependency) {
        self.dependency = dependency

        dependency.interactor.initUser()

        categoryButtonsStatusDriver = Driver.combineLatest(
            dependency.interactor.busstopStatusDriver,
            dependency.interactor.culturalPropertyStatusDriver,
            dependency.interactor.restaurantMarkersDriver,
            dependency.interactor.famousSitesStatusDriver
        ).map({ busstop, culturalProperty, restaurantMarkers, famousSites -> CategoryButtonsStatusViewData in
            var buttonsStatus = CategoryButtonsStatusViewData()
            buttonsStatus.busstop = busstop
            buttonsStatus.culturalProperty = culturalProperty
            buttonsStatus.restaurant =
                restaurantMarkers.count > 0 ? CategoryButtonStatus.visible : CategoryButtonStatus.hidden
            buttonsStatus.famousSites = famousSites

            return buttonsStatus
        }
        )

        restaurantMarkersDriver = dependency.interactor.restaurantMarkersDriver
            .map({ markers -> [CustomMGLPointAnnotation] in
                markers.map { marker -> CustomMGLPointAnnotation in
                    let viewData = RestaurantMarkerViewData(entity: marker)
                    return CustomMGLPointAnnotation(viewData: viewData)
                }
            })
    }

    func bindMapView(input: MapViewInput) {
        mapCenterPositionDriver = input.compassButtonTapEvent
            .map({ [weak self] _ -> MapCenterPosition in
                guard let self = self else { return MapCenterPosition.kyotoCity }

                let next = self.mapCenterPosition.next()
                self.mapCenterPosition = next
                return next
            })
            .asDriver()
    }

    func updateVisibleMarkers(_ markers: [MarkerEntityProtocol]) {
        dependency.interactor.updateMarkersFromStyleLayers(entity: markers)
    }

    func tapOnCallout(viewData: MarkerViewDataProtocol) {
        dependency.router.transitionToDetailViewController(inject: viewData)
    }

    func updateViewpoint(centerCoordinate: CLLocationCoordinate2D) {
        dependency.interactor.updateMapViewViewpoint(centerCoordinate: centerCoordinate)
    }

    func fetchLanguageSetting(complition: (LanguageSettings) -> Void) {
        dependency.interactor.fetchLanguageSetting { language in
            complition(language)
        }
    }
}
