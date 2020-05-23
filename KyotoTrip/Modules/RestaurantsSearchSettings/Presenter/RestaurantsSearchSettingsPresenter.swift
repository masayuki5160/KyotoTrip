//
//  RestaurantsSearchSettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxSwift
import RxCocoa

protocol RestaurantsSearchSettingsPresenterProtocol {
    var restaurantsSearchSettingsRowsDriver: Driver<[RestaurantsSearchSettingCellEntity]>{ get }
    func bindRestauransSearchSettingsView(input: RestauransSearchSettingsView)
    func saveRestaurantsSettings()
}

class RestaurantsSearchSettingsPresenter: RestaurantsSearchSettingsPresenterProtocol {
    
    struct Dependency {
        let interactor: RestaurantsSearchSettingsInteractorProtocol
        let router: RestaurantsSearchSettingsRouterProtocol
        let commonPresenter: CommonSettingsPresenterProtocol
    }
    
    var restaurantsSearchSettingsRowsDriver: Driver<[RestaurantsSearchSettingCellEntity]> {
        return restaurantsSearchSettingsRows.asDriver()
    }
    
    private let dependency: Dependency
    private var restaurantsRequestParam = RestaurantsRequestParamEntity()
    private let restaurantsSearchSettingsTableData: [String] = [
        "検索範囲",
        "英語スタッフ",
        "韓国語スタッフ",
        "中国語スタッフ",
        "ベジタリアンメニュー",
        "クレジットカード",
        "個室",
        "Wifi",
        "禁煙"
    ]
    private var restaurantsSearchRangeDictionary: [RestaurantsRequestParamEntity.SearchRange:String] {
        return dependency.commonPresenter.restaurantsSearchRangeDictionary
    }
    private let restaurantsSearchSettingsRows = BehaviorRelay<[RestaurantsSearchSettingCellEntity]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        dependency.interactor.fetchRestaurantsRequestParam { [weak self] savedSettings in
            self?.restaurantsRequestParam = savedSettings

            let searchSettings = self?.buildRestaurantsSettingRows(settings: savedSettings)
            restaurantsSearchSettingsRows.accept(searchSettings ?? [])
        }
    }
    
    func bindRestauransSearchSettingsView(input: RestauransSearchSettingsView) {
        input.selectedCellEntity.drive(onNext: { [weak self] entity in
            guard let self = self else { return }
            /// FIXME: Change to other good code
            switch entity.title {
            case self.restaurantsSearchSettingsTableData[0]:// 検索範囲
                let vc = AppDefaultDependencies().assembleSettingsRestaurantsSearchRangeModule()
                /// TODO: Routeを導入する
                // navigationController?.pushViewController(vc, animated: true)
            case self.restaurantsSearchSettingsTableData[1]:// 英語スタッフ
                if entity.isSelected {
                    self.restaurantsRequestParam.englishSpeakingStaff = .off
                } else {
                    self.restaurantsRequestParam.englishSpeakingStaff = .on
                }
            case self.restaurantsSearchSettingsTableData[2]:// 韓国語スタッフ
                if entity.isSelected {
                    self.restaurantsRequestParam.koreanSpeakingStaff = .off
                } else {
                    self.restaurantsRequestParam.koreanSpeakingStaff = .on
                }
            case self.restaurantsSearchSettingsTableData[3]:// 中国語スタッフ
                if entity.isSelected {
                    self.restaurantsRequestParam.chineseSpeakingStaff = .off
                } else {
                    self.restaurantsRequestParam.chineseSpeakingStaff = .on
                }
            case self.restaurantsSearchSettingsTableData[4]:// ベジタリアンメニュー
                if entity.isSelected {
                    self.restaurantsRequestParam.vegetarianMenuOptions = .off
                } else {
                    self.restaurantsRequestParam.vegetarianMenuOptions = .on
                }
            case self.restaurantsSearchSettingsTableData[5]:// クレジットカード
                if entity.isSelected {
                    self.restaurantsRequestParam.card = .off
                } else {
                    self.restaurantsRequestParam.card = .on
                }
            case self.restaurantsSearchSettingsTableData[6]:// 個室
                if entity.isSelected {
                    self.restaurantsRequestParam.privateRoom = .off
                } else {
                    self.restaurantsRequestParam.privateRoom = .on
                }
            case self.restaurantsSearchSettingsTableData[7]:// Wifi
                if entity.isSelected {
                    self.restaurantsRequestParam.wifi = .off
                } else {
                    self.restaurantsRequestParam.wifi = .on
                }
            case self.restaurantsSearchSettingsTableData[8]:// 禁煙
                if entity.isSelected {
                    self.restaurantsRequestParam.noSmoking = .off
                } else {
                    self.restaurantsRequestParam.noSmoking = .on
                }
            default:
                break
            }
                        
            let searchSettings =
                self.buildRestaurantsSettingRows(settings: self.restaurantsRequestParam)
            self.restaurantsSearchSettingsRows.accept(searchSettings)
        }).disposed(by: disposeBag)
    }
    
    func saveRestaurantsSettings() {
        dependency.interactor.saveRestaurantsRequestParam(entity: restaurantsRequestParam)
    }
}

private extension RestaurantsSearchSettingsPresenter {
    private func buildRestaurantsSettingRows(settings: RestaurantsRequestParamEntity) -> [RestaurantsSearchSettingCellEntity] {
        var searchSettingRows: [RestaurantsSearchSettingCellEntity] = []
        
        /// FIXME: Change to other good code
        for index in 0..<restaurantsSearchSettingsTableData.count {
            var model = RestaurantsSearchSettingCellEntity()

            model.title = restaurantsSearchSettingsTableData[index]
            switch index {
            case 0:// 検索範囲
                model.detail = dependency.commonPresenter.convertToRangeString(from: settings.range)
            case 1:// 英語スタッフ
                model.isSelected = settings.englishSpeakingStaff == .on ? true : false
            case 2:// 韓国語スタッフ
                model.isSelected = settings.koreanSpeakingStaff == .on ? true : false
            case 3:// 中国語スタッフ
                model.isSelected = settings.chineseSpeakingStaff == .on ? true : false
            case 4:// ベジタリアンメニュー
                model.isSelected = settings.vegetarianMenuOptions == .on ? true : false
            case 5:// クレジットカード
                model.isSelected = settings.card == .on ? true : false
            case 6:// 個室
                model.isSelected = settings.privateRoom == .on ? true : false
            case 7:// Wifi
                model.isSelected = settings.wifi == .on ? true : false
            case 8:// 禁煙
                model.isSelected = settings.noSmoking == .on ? true : false
            default:
                break
            }
            
            searchSettingRows.append(model)
        }

        return searchSettingRows
    }
}
