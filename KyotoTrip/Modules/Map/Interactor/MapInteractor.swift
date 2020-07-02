//
//  MapInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/10.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxSwift
import RxCocoa
import CoreLocation

protocol MapInteractorProtocol: AnyObject {
    /// Output from Interactor for Presenter
    var restaurantMarkersDriver: Driver<[RestaurantMarkerEntity]> { get }
    var visibleMarkers: Driver<[MarkerEntityProtocol]> { get }
    var culturalPropertyStatusDriver: Driver<CategoryButtonStatus> { get }
    var busstopStatusDriver: Driver<CategoryButtonStatus> { get }
    var famousSitesStatusDriver: Driver<CategoryButtonStatus> { get }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> { get }
    func fetchLanguageSetting(complition: (LanguageSettings) -> Void)

    /// Input to Interactor
    func updateMarkersFromStyleLayers(entity: [MarkerEntityProtocol])
    func didSelectCategoryViewCell(viewData: MarkerViewDataProtocol)
    func updateMapViewViewpoint(centerCoordinate: CLLocationCoordinate2D)
    func didSelectBusstopButton(nextStatus: CategoryButtonStatus)
    func didSelectCulturalPropertyButton(nextStatus: CategoryButtonStatus)
    func didSelectRestaurantButton(nextStatus: CategoryButtonStatus)
    func didSelectFamousSitesButton(nextStatus: CategoryButtonStatus)
    func initUser()
}

class MapInteractor: MapInteractorProtocol {
    struct Dependency {
        let searchGateway: RestaurantsSearchGatewayProtocol
        let requestParamGateway: RestaurantsRequestParamGatewayProtocol
        let languageSettingGateway: LanguageSettingGatewayProtocol
        let userInfoGateway: UserInfoGatewayProtocol
    }

    var restaurantMarkersDriver: Driver<[RestaurantMarkerEntity]> {
        restaurantMarkersRelay.asDriver()
    }
    var visibleMarkers: Driver<[MarkerEntityProtocol]> {
        let driver = Driver.combineLatest(
            restaurantMarkersDriver,
            markersFromStyleLayersRelay.asDriver()
        ) {
            $0 + $1
        }
        return driver
    }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> {
        selectedCategoryViewCellRelay.asSignal()
    }
    var culturalPropertyStatusDriver: Driver<CategoryButtonStatus> {
        culturalPropertyStatusRelay.asDriver()
    }
    var busstopStatusDriver: Driver<CategoryButtonStatus> {
        busstopStatusRelay.asDriver()
    }
    var famousSitesStatusDriver: Driver<CategoryButtonStatus> {
        famousSitesStatusRelay.asDriver()
    }

    private let restaurantMarkersRelay = BehaviorRelay<[RestaurantMarkerEntity]>(value: [])
    private let markersFromStyleLayersRelay = BehaviorRelay<[MarkerEntityProtocol]>(value: [])
    private let selectedCategoryViewCellRelay = PublishRelay<MarkerViewDataProtocol>()
    private let culturalPropertyStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)
    private let busstopStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)
    private let famousSitesStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)
    private var dependency: Dependency
    private var mapViewCenterCoordinate: CLLocationCoordinate2D
        = CLLocationCoordinate2D(latitude: MapView.kyotoStationLat, longitude: MapView.kyotoStationLong)

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func fetchLanguageSetting(complition: (LanguageSettings) -> Void) {
        dependency.languageSettingGateway.fetch { response in
            switch response {
            case .success(let language):
                complition(language)
            case .failure(_):
                // Return Japanese as default setting when failure
                complition(LanguageSettings.japanese)
            }
        }
    }

    func updateMapViewViewpoint(centerCoordinate: CLLocationCoordinate2D) {
        mapViewCenterCoordinate = centerCoordinate
    }

    func updateMarkersFromStyleLayers(entity: [MarkerEntityProtocol]) {
        markersFromStyleLayersRelay.accept(entity)
    }

    func didSelectCategoryViewCell(viewData: MarkerViewDataProtocol) {
        selectedCategoryViewCellRelay.accept(viewData)
    }

    func didSelectBusstopButton(nextStatus: CategoryButtonStatus) {
        busstopStatusRelay.accept(nextStatus)
    }

    func didSelectCulturalPropertyButton(nextStatus: CategoryButtonStatus) {
        culturalPropertyStatusRelay.accept(nextStatus)
    }

    func didSelectRestaurantButton(nextStatus: CategoryButtonStatus) {
        switch nextStatus {
        case .hidden:
            restaurantMarkersRelay.accept([])

        case .visible:
            fetchRestaurants { [weak self] response in
                guard let self = self else { return }

                var markers: [RestaurantMarkerEntity] = []
                switch response {
                case .success(let restaurantMarkers):
                    markers = restaurantMarkers

                default:
                    // TODO: エラー状態をpresenterに渡せるようにしたい
                    break
                }

                self.restaurantMarkersRelay.accept(markers)
            }
        }
    }

    func didSelectFamousSitesButton(nextStatus: CategoryButtonStatus) {
        famousSitesStatusRelay.accept(nextStatus)
    }

    func initUser() {
        dependency.userInfoGateway.fetchLaunchedBefore { [weak self] response in
            switch response {
            case .success(let launchedBefore):
                if launchedBefore {
                    /* Not first launch */
                } else {
                    /* First launch */

                    // Get language settings from device and set it to restaurant search settings as default language settings
                    let languages = NSLocale.preferredLanguages
                    let firstLanguage = languages[0].prefix(2)

                    var restaurantSearchSettings = RestaurantsRequestParamEntity()
                    if firstLanguage == "en" {
                        restaurantSearchSettings.language = .english
                        self?.dependency.languageSettingGateway.save(setting: .english)
                    } else {
                        restaurantSearchSettings.language = .japanese
                        self?.dependency.languageSettingGateway.save(setting: .japanese)
                    }

                    self?.dependency.requestParamGateway.save(entity: restaurantSearchSettings)
                    self?.dependency.userInfoGateway.save(launchedBefore: true)
                }
            default:
                break
            }
        }
    }
}

private extension MapInteractor {
    private func fetchRestaurants(complition: @escaping (Result<[RestaurantMarkerEntity], RestaurantsSearchResponseError>) -> Void) {
        createRestaurantsRequestParam(location: mapViewCenterCoordinate) { [weak self] requestParam in
            switch requestParam.langSettingRequestParam {
            case .english:
                self?.dependency.searchGateway.fetchForEng(param: requestParam, complition: { [weak self] response in
                    guard let self = self else { return }

                    switch response {
                    case .success(let restaurants):
                        var markers: [RestaurantMarkerEntity] = []
                        for restaurant in restaurants.rest {
                            let marker = self.createRestaurantMarkerForEnglish(source: restaurant)
                            markers.append(marker)
                        }

                        complition(.success(markers))
                    case .failure(let error):
                        complition(.failure(error))
                    }
                })
            default:
                self?.dependency.searchGateway.fetch(param: requestParam) { [weak self] response in
                    guard let self = self else { return }

                    switch response {
                    case .success(let restaurants):
                        var markers: [RestaurantMarkerEntity] = []
                        for restaurant in restaurants.rest {
                            let marker = self.createRestaurantMarker(source: restaurant)
                            markers.append(marker)
                        }

                        complition(.success(markers))

                    case .failure(let error):
                        complition(.failure(error))
                    }
                }
            }

        }
    }

    private func createRestaurantsRequestParam(location: CLLocationCoordinate2D, compliton: (RestaurantsRequestParamEntity) -> Void) {
        dependency.requestParamGateway.fetch { response in

            switch response {
            case .failure(_):
                // Set default settings
                let settings = RestaurantsRequestParamEntity()
                compliton(settings)

            case .success(let savedSettings):
                var settings = savedSettings
                settings.latitude = String(location.latitude)
                settings.longitude = String(location.longitude)

                self.dependency.languageSettingGateway.fetch { response in
                    switch response {
                    case .success(let language):
                        settings.language = language
                    case .failure(_):
                        // Set Japanese as default setting
                        settings.language = .japanese
                    }

                    compliton(settings)
                }
            }
        }
    }

    private func createRestaurantMarker(source: RestaurantEntity) -> RestaurantMarkerEntity {
        let latitude = atof(source.location.latitudeWgs84)
        let longitude = atof(source.location.longitudeWgs84)
        return RestaurantMarkerEntity(
            title: source.name.name,
            subtitle: source.categories.category,
            coordinate: CLLocationCoordinate2DMake(latitude, longitude),
            type: .restaurant,
            detail: source
        )
    }

    private func createRestaurantMarkerForEnglish(source: RestaurantForEnglishEntity) -> RestaurantMarkerEntity {
        let latitude = atof(source.location.latitudeWgs84)
        let longitude = atof(source.location.longitudeWgs84)
        let restaurantEntity = source.convertToRestaurntEntity()
        return RestaurantMarkerEntity(
            title: source.name.name,
            subtitle: source.categories.categoryNameS[0],
            coordinate: CLLocationCoordinate2DMake(latitude, longitude),
            type: .restaurant,
            detail: restaurantEntity
        )
    }
}
