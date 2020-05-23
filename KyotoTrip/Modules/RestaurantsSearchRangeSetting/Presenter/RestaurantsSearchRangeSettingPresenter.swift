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
    var searchRangeRowsDriver: Driver<[RestaurantsSearchRangeCellEntity]>{ get }
}

struct RestauransSearchRangeSettingView {
    let selectedCellEntity: Driver<RestaurantsSearchRangeCellEntity>
}

class RestaurantsSearchRangeSettingPresenter: RestaurantsSearchRangeSettingPresenterProtocol {
    // MARK: Properties

    struct Dependency {
        let interactor: RestaurantsSearchRangeSettingInteractorProtocol
        let router: RestaurantsSearchRangeSettingRouterProtocol
        let commonPresenter: CommonSettingsPresenterProtocol
    }

    var searchRangeRowsDriver: Driver<[RestaurantsSearchRangeCellEntity]> {
        return restaurantsSearchRangeSettingsRows.asDriver()
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()
    private var restaurantsRequestParam = RestaurantsRequestParamEntity()
    private let restaurantsSearchRangeSettingsRows =
        BehaviorRelay<[RestaurantsSearchRangeCellEntity]>(value: [])

    init(dependency: Dependency) {
        self.dependency = dependency
        loadSettings()
    }
    
    // MARK: Public functions
    
    func bindView(input: RestauransSearchRangeSettingView) {
        input.selectedCellEntity.drive(onNext: { [weak self] entity in
            guard let self = self else { return }

            self.restaurantsRequestParam.range =
                self.dependency.commonPresenter.convertToSearchRange(rangeString: entity.range)
            
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
    
    private func buildSearchRangeRows(settings: RestaurantsRequestParamEntity) -> [RestaurantsSearchRangeCellEntity] {
        var searchRangeRows: [RestaurantsSearchRangeCellEntity] = []
        let searchRangeDictionary = dependency.commonPresenter.restaurantsSearchRangeDictionary
        
        for (_, val) in searchRangeDictionary {
            var model = RestaurantsSearchRangeCellEntity()
            model.range = val
            let rangeString = dependency.commonPresenter.convertToRangeString(from: settings.range)
            if rangeString == val {
                model.isSelected = true
            } else {
                model.isSelected = false
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
