//
//  AppSettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import UIKit

protocol AppSettingsPresenterProtocol {
    func cellForSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
    func cellForRestaurantsSearchSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
    func saveRestaurantsSettings(_ tableView: UITableView, _ indexPaths: [IndexPath])
    var settingsTableSectionTitle: [String] { get }
    var settingsTableData: [[String]] { get }
    var restaurantsSearchSettingsTableData: [String] { get }
    var restaurantsSearchRangeSettingsTableData: [String] { get }
}

class AppSettingsPresenter: AppSettingsPresenterProtocol {
        
    struct Dependency {
        let interactor: AppSettingsInteractorProtocol
    }
    
    let settingsTableSectionTitle = [
        "情報",
        "アプリ設定"
    ]
    let settingsTableData: [[String]]
    let restaurantsSearchSettingsTableData: [String] = [
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
    let restaurantsSearchRangeSettingsTableData: [String] = [
        "300m",
        "500m",
        "1000m",
        "2000m",
        "3000m"
    ]
        
    private let dependency: Dependency
    private let basicItems: [String] = [
        "バージョン",
        "ライセンス"
    ]
    private let settingItems: [String] = [
        "言語設定",
        "飲食店検索設定"
    ]

    init(dependency: Dependency) {
        self.dependency = dependency

        settingsTableData = [
            basicItems,
            settingItems
        ]
    }
    
    func cellForSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let items = settingsTableData[indexPath.section]

        switch indexPath.section {
        case 0:// 情報セクション
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithCurrentParam.id, for: indexPath) as! SettingsTableViewCellWithCurrentParam
                cell.title.text = items[indexPath.row]
                cell.currentParam.text = "1.x.x"
                cell.accessoryType = .none
                cell.selectionStyle = .none
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.id, for: indexPath) as! SettingsTableViewCell
                cell.title.text = items[indexPath.row]
                
                return cell
            }
        case 1:// アプリ設定セクション
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.id, for: indexPath) as! SettingsTableViewCell
            cell.title.text = items[indexPath.row]

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            cell.title.text = "none"

            return cell
        }
    }
    
    func cellForRestaurantsSearchSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        return createRestaurantsSearchSettingsCell(tableView, indexPath: indexPath)
    }
    
    func saveRestaurantsSettings(_ tableView: UITableView, _ indexPaths: [IndexPath]) {
        var settings = RestaurantsRequestParamEntity().load()
        
        for cursorIndexPath in indexPaths {
            if cursorIndexPath.row == 0 {
                // No nedd to save restaurants search range setting cell.
                // Save at SettingsRestaurantsSearchRangeViewController.
                continue
            }
            
            let cell = tableView.cellForRow(at: cursorIndexPath) as! SettingsTableViewCellWithSwitch
            switch cursorIndexPath.row {
            case 1:// 英語スタッフ
                settings.englishSpeakingStaff = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            case 2:// 韓国語スタッフ
                settings.koreanSpeakingStaff = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            case 3:// 中国語スタッフ
                settings.chineseSpeakingStaff = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            case 4:// ベジタリアンメニュー
                settings.vegetarianMenuOptions = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            case 5:// クレジットカード
                settings.card = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            case 6:// 個室
                settings.privateRoom = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            case 7:// Wifi
                settings.wifi = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            case 8:// 禁煙
                settings.noSmoking = dependency.interactor.uiSwitchStatusToRequestFlg(cell.statusSwitch.isOn)
            default:
                break
            }
        }
        
        settings.save()
    }

}

private extension AppSettingsPresenter {
    private func createRestaurantsSearchSettingsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {// For restaurants search range setting cell
            let restaurantSearchSettings = RestaurantsRequestParamEntity().load()
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithCurrentParam.id, for: indexPath) as! SettingsTableViewCellWithCurrentParam
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.currentParam.text = restaurantSearchSettings.rangeStr
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

            return cell
        } else {// Other cells
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            
            return loadAndSetSavedStatusToUISwitchStatus(cell, indexPath: indexPath)
        }
    }
    
    private func loadAndSetSavedStatusToUISwitchStatus(_ cell: SettingsTableViewCellWithSwitch, indexPath: IndexPath) -> SettingsTableViewCellWithSwitch {
        let restaurantSearchSettings = RestaurantsRequestParamEntity().load()
        
        switch indexPath.row {
        case 1:// 英語スタッフ
            cell.statusSwitch.isOn = restaurantSearchSettings.englishSpeakingStaff == .on ? true : false
        case 2:// 韓国語スタッフ
            cell.statusSwitch.isOn = restaurantSearchSettings.koreanSpeakingStaff == .on ? true : false
        case 3:// 中国語スタッフ
            cell.statusSwitch.isOn = restaurantSearchSettings.chineseSpeakingStaff == .on ? true : false
        case 4:// ベジタリアンメニュー
            cell.statusSwitch.isOn = restaurantSearchSettings.vegetarianMenuOptions == .on ? true : false
        case 5:// クレジットカード
            cell.statusSwitch.isOn = restaurantSearchSettings.card == .on ? true : false
        case 6:// 個室
            cell.statusSwitch.isOn = restaurantSearchSettings.privateRoom == .on ? true : false
        case 7:// Wifi
            cell.statusSwitch.isOn = restaurantSearchSettings.wifi == .on ? true : false
        case 8:// 禁煙
            cell.statusSwitch.isOn = restaurantSearchSettings.noSmoking == .on ? true : false
        default:
            break
        }
        
        return cell
    }
}
