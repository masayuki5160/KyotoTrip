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
    let culturalPropertyButton: Signal<Void>
    let busstopButton: Signal<Void>
    let restaurantButton: Signal<Void>
    let selectedCell: Signal<CategoryCellViewData>
}

class CategoryPresenter: CategoryPresenterProtocol {

    struct Dependency {
        let interactor: MapInteractorProtocol
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
        
        dependency.interactor.visibleMarkers.map { markers -> [CategoryCellViewData] in
            markers.map { [weak self] marker -> CategoryCellViewData in
                CategoryCellViewData(
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
        input.culturalPropertyButton.emit(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.nextVisibleLayer(
                target: .CulturalProperty,
                current: self.dependency.interactor.markerCategory
            )
            self.dependency.interactor.updateVisibleLayer(entity: nextVisibleLayer)
            self.dependency.interactor.updateRestaurantMarkers(entity: [])
        }).disposed(by: disposeBag)
        
        input.busstopButton.emit(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.nextVisibleLayer(
                target: .Busstop,
                current: self.dependency.interactor.markerCategory
            )
            self.dependency.interactor.updateVisibleLayer(entity: nextVisibleLayer)
            self.dependency.interactor.updateRestaurantMarkers(entity: [])
        }).disposed(by: disposeBag)
        
        input.restaurantButton.emit(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.nextVisibleLayer(
                target: .Restaurant,
                current: self.dependency.interactor.markerCategory
            )
            
            switch nextVisibleLayer.restaurant {
            case .hidden:
                self.dependency.interactor.updateRestaurantMarkers(entity: [])
            case .visible:
                self.fetchRestaurantsEntity()
            }
            
            self.dependency.interactor.updateVisibleLayer(entity: nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.selectedCell.emit(onNext: { [weak self] (cell) in
            let markerEntity = cell.detail
            self?.dependency.interactor.didSelectCategoryViewCell(entity: markerEntity)
        }).disposed(by: disposeBag)
    }
}

private extension CategoryPresenter {
    func fetchRestaurantsEntity() {
        let centerCoordinate = dependency.interactor.mapViewCenterCoordinate
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
            
            self.dependency.interactor.updateRestaurantMarkers(entity: markers)
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
