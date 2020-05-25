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
    var visibleFeatureEntityDriver: Driver<[VisibleFeatureProtocol]> { get }
    var visibleFeatureRestaurantEntityDriver: Driver<[VisibleFeatureProtocol]> { get }
    func bindCategoryView(input: CategoryViewInput)
    func categoryTableViewCellIconName(_ category: VisibleFeatureCategory) -> String
}

struct CategoryViewInput {
    let culturalPropertyButton: Driver<Void>
    let busstopButton: Driver<Void>
    let restaurantButton: Driver<Void>
    let tableViewCell: Driver<VisibleFeatureProtocol>
}

class CategoryPresenter: CategoryPresenterProtocol {
    
    struct Dependency {
        let interactor: CategoryInteractorProtocol
        let commonPresenter: CommonMapPresenterProtocol
        let router: CategoryRouterProtocol
    }
    
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    
    var visibleFeatureEntityDriver: Driver<[VisibleFeatureProtocol]>
    var visibleFeatureRestaurantEntityDriver: Driver<[VisibleFeatureProtocol]>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        visibleFeatureRestaurantEntityDriver =
            dependency.commonPresenter.visibleFeatureRestaurantEntity.asDriver()
        visibleFeatureEntityDriver =
            dependency.commonPresenter.visibleFeatureEntity.asDriver()
    }
    
    func bindCategoryView(input: CategoryViewInput) {
        input.culturalPropertyButton.drive(onNext: { [weak self] in
            guard let self = self else { return }

            let nextVisibleLayer = self.dependency.interactor.nextVisibleLayer(
                target: .CulturalProperty,
                current: self.dependency.commonPresenter.visibleLayerEntity.value
            )
            
            self.dependency.commonPresenter.visibleLayerEntity.accept(nextVisibleLayer)
            self.dependency.commonPresenter.visibleFeatureRestaurantEntity.accept([])
        }).disposed(by: disposeBag)
        
        input.busstopButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.dependency.interactor.nextVisibleLayer(
                target: .Busstop,
                current: self.dependency.commonPresenter.visibleLayerEntity.value
            )
            
            self.dependency.commonPresenter.visibleLayerEntity.accept(nextVisibleLayer)
            self.dependency.commonPresenter.visibleFeatureRestaurantEntity.accept([])
        }).disposed(by: disposeBag)
        
        input.restaurantButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.dependency.interactor.nextVisibleLayer(
                target: .Restaurant,
                current: self.dependency.commonPresenter.visibleLayerEntity.value
            )
            
            switch nextVisibleLayer.restaurant {
            case .hidden:
                self.dependency.commonPresenter.visibleFeatureRestaurantEntity.accept([])
            case .visible:
                self.fetchRestaurantsEntity()
            }
            
            self.dependency.commonPresenter.visibleLayerEntity.accept(nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.tableViewCell.drive(onNext: { [weak self] (feature) in
            self?.dependency.commonPresenter.selectedCategoryViewCellRelay.accept(feature)
        }).disposed(by: disposeBag)
    }
    
    func categoryTableViewCellIconName(_ category: VisibleFeatureCategory) -> String {
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

private extension CategoryPresenter {
    func fetchRestaurantsEntity() {
        self.dependency.commonPresenter.centerCoordinate { centerCoordinate in
            dependency.interactor.fetchRestaurants(location: centerCoordinate) { [weak self] (response) in
                guard let self = self else { return }

                var restaurantFeatures: [RestaurantFeatureEntity] = []
                switch response {
                case .success(let restaurantsSearchResultEntity):
                    for restaurant in restaurantsSearchResultEntity.rest {
                        let featureEntity = self.dependency.interactor.createRestaurantVisibleFeature(source: restaurant)
                        restaurantFeatures.append(featureEntity)
                    }
                case .failure(let error):
                    switch error {
                    case .entryNotFound:
                        self.dependency.router.showNoEntoryAlert()
                    default:
                        self.dependency.router.showUnknownErrorAlert()
                    }
                }
                
                self.dependency.commonPresenter.visibleFeatureRestaurantEntity.accept(restaurantFeatures)
            }
        }
    }
}
