//
//  CategoryPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxSwift
import RxCocoa
import Mapbox

protocol CategoryPresenterProtocol {
    /// Output from Presenter
    var cellsDriver: Driver<[CategoryCellViewData]> { get }
    /// Input to Presenter
    func bindCategoryView(input: CategoryViewInput)
}

struct CategoryViewInput {
    let culturalPropertyButton: Driver<Void>
    let busstopButton: Driver<Void>
    let restaurantButton: Driver<Void>
    let selectedCell: Driver<CategoryCellViewData>
}

class CategoryPresenter: CategoryPresenterProtocol {

    struct Dependency {
        let interactor: MapInteractorProtocol
        let sharedPresenter: SharedMapPresenterProtocol
        let router: CategoryRouterProtocol
    }
    
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    
    private var cellsRelay = BehaviorRelay<[CategoryCellViewData]>(value: [])
    var cellsDriver: Driver<[CategoryCellViewData]> {
        return cellsRelay.asDriver()
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        Driver.combineLatest(
            dependency.sharedPresenter.restaurantMarkersRelay.asDriver(),
            dependency.sharedPresenter.markersFromStyleLayersRelay.asDriver()
        ){$0 + $1}.map { markers -> [CategoryCellViewData] in
            markers.map { [weak self] marker -> CategoryCellViewData in
                return CategoryCellViewData(
                    title: marker.title,
                    iconName: self?.categoryTableViewCellIconName(marker.type) ?? "",
                    detail: marker
                )
            }
        }.drive(onNext: { cells in
            self.cellsRelay.accept(cells)
        }).disposed(by: disposeBag)
    }
    
    func bindCategoryView(input: CategoryViewInput) {
        input.culturalPropertyButton.drive(onNext: { [weak self] in
            guard let self = self else { return }

            let nextVisibleLayer = self.nextVisibleLayer(
                target: .CulturalProperty,
                current: self.dependency.sharedPresenter.markerCategoryRelay.value
            )
            
            self.dependency.sharedPresenter.markerCategoryRelay.accept(nextVisibleLayer)
            self.dependency.sharedPresenter.restaurantMarkersRelay.accept([])
        }).disposed(by: disposeBag)
        
        input.busstopButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.nextVisibleLayer(
                target: .Busstop,
                current: self.dependency.sharedPresenter.markerCategoryRelay.value
            )
            
            self.dependency.sharedPresenter.markerCategoryRelay.accept(nextVisibleLayer)
            self.dependency.sharedPresenter.restaurantMarkersRelay.accept([])
        }).disposed(by: disposeBag)
        
        input.restaurantButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.nextVisibleLayer(
                target: .Restaurant,
                current: self.dependency.sharedPresenter.markerCategoryRelay.value
            )
            
            switch nextVisibleLayer.restaurant {
            case .hidden:
                self.dependency.sharedPresenter.restaurantMarkersRelay.accept([])
            case .visible:
                self.fetchRestaurantsEntity()
            }
            
            self.dependency.sharedPresenter.markerCategoryRelay.accept(nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.selectedCell.drive(onNext: { [weak self] (cell) in
            let markerEntity = cell.detail
            self?.dependency.sharedPresenter.selectedCategoryViewCellRelay.accept(markerEntity)
        }).disposed(by: disposeBag)
    }
}

private extension CategoryPresenter {
    func fetchRestaurantsEntity() {
        let centerCoordinate = dependency.sharedPresenter.mapViewCenterCoordinate
        dependency.interactor.fetchRestaurants(location: centerCoordinate) { [weak self] (response) in
            guard let self = self else { return }

            var markers: [RestaurantMarkerEntity] = []
            switch response {
            case .success(let restaurantMarkers):
                markers = restaurantMarkers
            case .failure(let error):
                switch error {
                case .entryNotFound:
                    self.dependency.router.showNoEntoryAlert()
                default:
                    self.dependency.router.showUnknownErrorAlert()
                }
            }
            
            self.dependency.sharedPresenter.restaurantMarkersRelay.accept(markers)
        }
    }
    
    private func nextVisibleLayer(target: MarkerCategory, current: MarkerCategoryEntity) -> MarkerCategoryEntity {
        return current.update(category: target)
    }
    
    private func categoryTableViewCellIconName(_ category: MarkerCategory) -> String {
        let iconName: String
        switch category {
        case .Busstop:
            iconName = CategoryTableViewCell.IconName.busstop
        case .CulturalProperty:
            iconName = CategoryTableViewCell.IconName.culturalProperty
        case .Restaurant:
            iconName = CategoryTableViewCell.IconName.restaurant
        default:
            // TODO: Set default icon name
            iconName = CategoryTableViewCell.IconName.busstop
        }
        
        return iconName
    }
}
