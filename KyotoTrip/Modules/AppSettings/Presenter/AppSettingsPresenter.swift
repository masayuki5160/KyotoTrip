//
//  AppSettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

protocol AppSettingsPresenterProtocol {
    func cellForSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell/// TODO: SettingViewControllerをリファクタしたら削除?
    func saveRestaurantsSettings()
    var settingsTableSectionTitle: [String] { get }/// TODO: SettingViewControllerをリファクタしたら削除?
    var settingsTableData: [[String]] { get }/// TODO: SettingViewControllerをリファクタしたら削除
    
    // MARK: Function to bind views
    func bindRestauransSearchSettingsView(input: RestauransSearchSettingsView)
    func bindRestauransSearchRangeSettingView(input: RestauransSearchRangeSettingView)
    
    // MARK: Output from Presenter
    var restaurantsSearchSettingsRowsDriver: Driver<[RestaurantsSearchSettingCellEntity]>{ get }
    var restaurantsSearchRangeSettingRowsDriver: Driver<[RestaurantsSearchRangeCellEntity]>{ get }
}

struct RestauransSearchSettingsView {
    let selectedCellEntity: Driver<RestaurantsSearchSettingCellEntity>
}

struct RestauransSearchRangeSettingView {
    let selectedCellEntity: Driver<RestaurantsSearchRangeCellEntity>
}

class AppSettingsPresenter: AppSettingsPresenterProtocol {
    // MARK: Properties

    struct Dependency {
        let interactor: AppSettingsInteractorProtocol
    }
    
    let settingsTableSectionTitle = [
        "情報",
        "アプリ設定"
    ]
    let settingsTableData: [[String]]
    var restaurantsSearchRangeSettingRowsDriver: Driver<[RestaurantsSearchRangeCellEntity]> {
        return restaurantsSearchRangeSettingsRows.asDriver()
    }
    var restaurantsSearchSettingsRowsDriver: Driver<[RestaurantsSearchSettingCellEntity]> {
        return restaurantsSearchSettingsRows.asDriver()
    }
    
    private let dependency: Dependency
    private let basicItems: [String] = [
        "バージョン",
        "ライセンス"
    ]
    private let settingItems: [String] = [
        "言語設定",
        "飲食店検索設定"
    ]
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
    private let restaurantsSearchRangeDictionary: [RestaurantsRequestParamEntity.SearchRange:String] = [
            RestaurantsRequestParamEntity.SearchRange.range300:  "300m",
            RestaurantsRequestParamEntity.SearchRange.range500:  "500m",
            RestaurantsRequestParamEntity.SearchRange.range1000: "1000m",
            RestaurantsRequestParamEntity.SearchRange.range2000: "2000m",
            RestaurantsRequestParamEntity.SearchRange.range3000: "3000m"
    ]
    private var restaurantsRequestParam = RestaurantsRequestParamEntity()
    private let restaurantsSearchRangeSettingsRows = BehaviorRelay<[RestaurantsSearchRangeCellEntity]>(value: [])
    private let restaurantsSearchSettingsRows =
        BehaviorRelay<[RestaurantsSearchSettingCellEntity]>(value: [])
    private let disposeBag = DisposeBag()

    // MARK: Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency

        settingsTableData = [
            basicItems,
            settingItems
        ]
        
        dependency.interactor.fetchRestaurantsRequestParam { [weak self] savedSettings in
            self?.restaurantsRequestParam = savedSettings

            let searchRangeRows = self?.buildSearchRangeRows(settings: savedSettings)
            restaurantsSearchRangeSettingsRows.accept(searchRangeRows ?? [])
            
            let searchSettings = self?.buildRestaurantsSettingRows(settings: savedSettings)
            restaurantsSearchSettingsRows.accept(searchSettings ?? [])
        }
    }
    
    func cellForSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let items = settingsTableData[indexPath.section]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SettingCell")
        cell.textLabel?.text = items[indexPath.row]

        switch indexPath.section {
        case 0:/// 情報セクション
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = appVersionString()
                cell.accessoryType = .none
                cell.selectionStyle = .none
            case 1:
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        case 1:/// アプリ設定セクション
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    func saveRestaurantsSettings() {
        dependency.interactor.saveRestaurantsRequestParam(entity: restaurantsRequestParam)
    }
    
    func bindRestauransSearchRangeSettingView(input: RestauransSearchRangeSettingView) {
        input.selectedCellEntity.drive(onNext: { [weak self] entity in
            guard let self = self else { return }

            self.restaurantsRequestParam.range =
                self.convertToSearchRange(rangeString: entity.range)
            
            let searchRangeRows = self.buildSearchRangeRows(settings: self.restaurantsRequestParam)
            self.restaurantsSearchRangeSettingsRows.accept(searchRangeRows)
        }).disposed(by: disposeBag)
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
}

private extension AppSettingsPresenter {
    // MARK: Private functions
    private func appVersionString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return "\(version).\(build)"
    }
    
    private func buildSearchRangeRows(settings: RestaurantsRequestParamEntity) -> [RestaurantsSearchRangeCellEntity] {
        var searchRangeRows: [RestaurantsSearchRangeCellEntity] = []
        for (_, val) in restaurantsSearchRangeDictionary {
            var model = RestaurantsSearchRangeCellEntity()
            model.range = val
            let rangeString = convertToRangeString(from: settings.range)
            if rangeString == val {
                model.isSelected = true
            } else {
                model.isSelected = false
            }
            
            searchRangeRows.append(model)
        }

        return searchRangeRows
    }
    
    private func buildRestaurantsSettingRows(settings: RestaurantsRequestParamEntity) -> [RestaurantsSearchSettingCellEntity] {
        var searchSettingRows: [RestaurantsSearchSettingCellEntity] = []
        
        /// FIXME: Change to other good code
        for index in 0..<restaurantsSearchSettingsTableData.count {
            var model = RestaurantsSearchSettingCellEntity()

            model.title = restaurantsSearchSettingsTableData[index]
            switch index {
            case 0:// 検索範囲
                model.detail = convertToRangeString(from: settings.range)
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
    
    private func convertToRangeString(from: RestaurantsRequestParamEntity.SearchRange) -> String {
        return restaurantsSearchRangeDictionary[from] ?? restaurantsSearchRangeDictionary[.range500]!
    }
    
    private func convertToSearchRange(rangeString: String) -> RestaurantsRequestParamEntity.SearchRange {
        let keys = restaurantsSearchRangeDictionary.filter{ $1 == rangeString }.keys
        return keys.first ?? RestaurantsRequestParamEntity.SearchRange.range500
    }
}
