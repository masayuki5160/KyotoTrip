//
//  RestaurantsSearchRangePresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxSwift
import RxCocoa

protocol RestaurantsSearchRangeSettingPresenterProtocol {
    func bindView(input: RestauransSearchRangeSettingView)
    func saveRestaurantsSettings()
    func reloadSettings()
    
    // MARK: Output from presenter
    var searchRangeRowsDriver: Driver<[RestaurantsSearchRangeCellViewData]>{ get }
}

struct RestauransSearchRangeSettingView {
    let selectedCellEntity: Driver<RestaurantsSearchRangeCellViewData>
}

class RestaurantsSearchRangeSettingPresenter: RestaurantsSearchRangeSettingPresenterProtocol {
    // MARK: Properties

    struct Dependency {
        let interactor: SettingsInteractorProtocol
        let router: RestaurantsSearchRangeSettingRouterProtocol
    }

    var searchRangeRowsDriver: Driver<[RestaurantsSearchRangeCellViewData]> {
        return restaurantsSearchRangeSettingsRows.asDriver()
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()
    private var restaurantsRequestParam = RestaurantsRequestParamEntity()
    private let restaurantsSearchRangeSettingsRows =
        BehaviorRelay<[RestaurantsSearchRangeCellViewData]>(value: [])
    
    private let restaurantsSearchRangeSettings = [
        RestaurantsRequestSearchRange.range300,
        RestaurantsRequestSearchRange.range500,
        RestaurantsRequestSearchRange.range1000,
        RestaurantsRequestSearchRange.range2000,
        RestaurantsRequestSearchRange.range3000
    ]

    init(dependency: Dependency) {
        self.dependency = dependency
        loadSettings()
    }
    
    // MARK: Public functions
    
    func bindView(input: RestauransSearchRangeSettingView) {
        input.selectedCellEntity.drive(onNext: { [weak self] entity in
            guard let self = self else { return }

            self.restaurantsRequestParam.range = entity.range
            let searchRangeRows = self.buildSearchRangeRows(settings: self.restaurantsRequestParam)
            self.restaurantsSearchRangeSettingsRows.accept(searchRangeRows)
        }).disposed(by: disposeBag)
    }
    
    func saveRestaurantsSettings() {
        dependency.interactor.saveRestaurantsRequestParam(entity: restaurantsRequestParam)
    }
    
    func reloadSettings() {
        loadSettings()
    }
}

private extension RestaurantsSearchRangeSettingPresenter {
    // MARK: Private functions
    
    private func buildSearchRangeRows(settings: RestaurantsRequestParamEntity) -> [RestaurantsSearchRangeCellViewData] {
        var searchRangeRows: [RestaurantsSearchRangeCellViewData] = []
        
        for range in restaurantsSearchRangeSettings {
            var model = RestaurantsSearchRangeCellViewData(range: range, isSelected: false)
            if settings.range == range {
                model.isSelected = true
            }
            
            searchRangeRows.append(model)
        }

        return searchRangeRows
    }
    
    private func loadSettings() {
        dependency.interactor.fetchRestaurantsRequestParam { [weak self] savedSettings in
            self?.restaurantsRequestParam = savedSettings
            
            let searchRangeRows = self?.buildSearchRangeRows(settings: savedSettings)
            restaurantsSearchRangeSettingsRows.accept(searchRangeRows ?? [])
        }
    }
}
