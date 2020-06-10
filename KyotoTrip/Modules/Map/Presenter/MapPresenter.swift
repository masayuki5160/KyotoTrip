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
    let compassButtonTapEvent: Signal<Void>
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

    var userPositionButtonStatusSignal: Signal<UserPosition>! { get }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> { get }
    var categoryButtonsStatusDriver: Driver<CategoryButtonsStatusViewData> { get }
    var restaurantMarkersDriver: Driver<(CategoryButtonStatus, [CustomMGLPointAnnotation])> { get }
}

class MapPresenter: MapPresenterProtocol {
    // MARK: - Properties
    struct Dependency {
        let interactor: MapInteractorProtocol
        let router: MapRouterProtocol
    }

    static var layerIdentifiers: Set<String> = [
        BusstopMarkerEntity.layerId,
        CulturalPropertyMarkerEntity.layerId
    ]

    var userPositionButtonStatusSignal: Signal<UserPosition>!
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> {
        dependency.interactor.selectedCategoryViewCellSignal
    }
    var categoryButtonsStatusDriver: Driver<CategoryButtonsStatusViewData>
    var restaurantMarkersDriver: Driver<(CategoryButtonStatus, [CustomMGLPointAnnotation])>

    private var dependency: Dependency
    private let disposeBag = DisposeBag()
    private var userPosition: UserPosition = .kyotoCity

    // MARK: - Public functions

    init(dependency: Dependency) {
        self.dependency = dependency

        categoryButtonsStatusDriver = Driver.combineLatest(
            dependency.interactor.busstopStatusDriver,
            dependency.interactor.culturalPropertyStatusDriver,
            dependency.interactor.restaurantStatusDriver
        ).map({ busstop, culturalProperty, restaurant -> CategoryButtonsStatusViewData in
            var buttonsStatus = CategoryButtonsStatusViewData()
            buttonsStatus.busstop = busstop
            buttonsStatus.culturalProperty = culturalProperty
            buttonsStatus.restaurant = restaurant

            return buttonsStatus
            }
        )

        restaurantMarkersDriver = Driver.combineLatest(
            dependency.interactor.restaurantStatusDriver,
            dependency.interactor.restaurantMarkersDriver
        ).map({ status, markers -> (CategoryButtonStatus, [CustomMGLPointAnnotation]) in
            let annotations = markers.map { marker -> CustomMGLPointAnnotation in
                let viewData = RestaurantMarkerViewData(entity: marker)
                return CustomMGLPointAnnotation(viewData: viewData)
            }
            return (status, annotations)
            }
        )
    }

    func bindMapView(input: MapViewInput) {
        userPositionButtonStatusSignal = input.compassButtonTapEvent.map { [weak self] _ -> UserPosition in
            guard let self = self else { return UserPosition.kyotoCity }

            let next = self.userPosition.next()
            self.userPosition = next
            return next
        }.asSignal()
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
}
