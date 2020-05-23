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
    func bindRestauransSearchRangeSettingView(input: RestauransSearchRangeSettingView)
    
    // MARK: Output from Presenter
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
        let commonPresenter: CommonSettingsPresenter
    }
    
    let settingsTableSectionTitle = [
        "情報",
        "アプリ設定"
    ]
    let settingsTableData: [[String]]
    var restaurantsSearchRangeSettingRowsDriver: Driver<[RestaurantsSearchRangeCellEntity]> {
        return restaurantsSearchRangeSettingsRows.asDriver()
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
    private var restaurantsSearchRangeDictionary: [RestaurantsRequestParamEntity.SearchRange:String] {
        return dependency.commonPresenter.restaurantsSearchRangeDictionary
    }
    private var restaurantsRequestParam = RestaurantsRequestParamEntity()
    private let restaurantsSearchRangeSettingsRows =
        BehaviorRelay<[RestaurantsSearchRangeCellEntity]>(value: [])
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

    private func convertToSearchRange(rangeString: String) -> RestaurantsRequestParamEntity.SearchRange {
        let keys = restaurantsSearchRangeDictionary.filter{ $1 == rangeString }.keys
        return keys.first ?? RestaurantsRequestParamEntity.SearchRange.range500
    }
}
