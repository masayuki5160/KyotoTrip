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
    func saveRestaurantsSettings(cells: [UITableViewCell])
    var settingsTableSectionTitle: [String] { get }
    var settingsTableData: [[String]] { get }
    var restaurantsSearchSettingsTableData: [String] { get }
}

class AppSettingsPresenter: AppSettingsPresenterProtocol {
        
    struct Dependency {
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
    
    // TODO: テストが難しいため修正(tableViewを知らなくてもいいようにする)
    func cellForSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let items = settingsTableData[indexPath.section]

        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellWithCurrentParam.id, for: indexPath) as! SettingTableViewCellWithCurrentParam
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.id, for: indexPath) as! SettingsTableViewCell
            cell.title.text = items[indexPath.row]

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            cell.title.text = "none"

            return cell
        }
    }
    
    // TODO: リファクタリング
    func cellForRestaurantsSearchSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let restaurantSearchSettings = RestaurantsRequestParamEntity().load()
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellWithCurrentParam.id, for: indexPath) as! SettingTableViewCellWithCurrentParam
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.currentParam.text = restaurantSearchSettings.rangeStr

            return cell

        case 1:// 英語スタッフ
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.englishSpeakingStaff == .on ? true : false

            return cell
        case 2:// 韓国語スタッフ
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.koreanSpeakingStaff == .on ? true : false

            return cell
        case 3:// 中国語スタッフ
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.chineseSpeakingStaff == .on ? true : false

            return cell
        case 4:// ベジタリアンメニュー
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.vegetarianMenuOptions == .on ? true : false

            return cell
        case 5:// クレジットカード
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.card == .on ? true : false

            return cell
        case 6:// 個室
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.privateRoom == .on ? true : false

            return cell
        case 7:// Wifi
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.wifi == .on ? true : false

            return cell
        case 8:// 禁煙
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.id, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]
            cell.statusSwitch.isOn = restaurantSearchSettings.noSmoking == .on ? true : false

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellWithCurrentParam.id, for: indexPath) as! SettingTableViewCellWithCurrentParam
            cell.title.text = restaurantsSearchSettingsTableData[indexPath.row]

            return cell
        }
    }
    
    // TODO: リファクタリング
    func saveRestaurantsSettings(cells: [UITableViewCell]) {
        var settings = RestaurantsRequestParamEntity().load()
        
        for cell in cells {
            if let castCell = cell as? SettingTableViewCellWithCurrentParam {
                switch castCell.currentParam.text {
                case "300m":
                    settings.range = .range300
                case "500m":
                    settings.range = .range500
                case "1000m":
                    settings.range = .range1000
                case "2000m":
                    settings.range = .range2000
                case "3000m":
                    settings.range = .range3000
                default:
                    break
                }
            } else {
                let castCell = cell as! SettingsTableViewCellWithSwitch

                switch castCell.title.text {
                case restaurantsSearchSettingsTableData[1]:// 英語スタッフ
                    settings.englishSpeakingStaff = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                case restaurantsSearchSettingsTableData[2]:// 韓国語スタッフ
                    settings.koreanSpeakingStaff = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                case restaurantsSearchSettingsTableData[3]:// 中国語スタッフ
                    settings.chineseSpeakingStaff = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                case restaurantsSearchSettingsTableData[4]:// ベジタリアンメニュー
                    settings.vegetarianMenuOptions = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                case restaurantsSearchSettingsTableData[5]:// クレジットカード
                    settings.card = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                case restaurantsSearchSettingsTableData[6]:// 個室
                    settings.privateRoom = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                case restaurantsSearchSettingsTableData[7]:// Wifi
                    settings.wifi = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                case restaurantsSearchSettingsTableData[8]:// 禁煙
                    settings.noSmoking = castCell.statusSwitch.isOn ? RestaurantsRequestParamEntity.RequestFilterFlg.on : RestaurantsRequestParamEntity.RequestFilterFlg.off
                default:
                    break
                }
            }
        }
        
        settings.save()
    }

}
