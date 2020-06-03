//
//  AppSettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import UIKit

protocol SettingsPresenterProtocol {
    func cellForSettings(indexPath: IndexPath) -> UITableViewCell
    func didSelectRowAt(indexPath: IndexPath)
    var settingsTableSectionTitle: [String] { get }
    var settingsTableData: [[String]] { get }
}

class SettingsPresenter: SettingsPresenterProtocol {

    // MARK: Properties

    struct Dependency {
        let interactor: SettingsInteractorProtocol
        let router: SettingsRouterProtocol
    }
    
    let settingsTableSectionTitle = [
        "情報",
        "アプリ設定"
    ]
    let settingsTableData: [[String]]
    
    private let dependency: Dependency
    private let basicItems: [String] = [
        "バージョン",
        "ライセンス"
    ]
    private let settingItems: [String] = [
        "言語設定",
        "飲食店検索設定"
    ]

    // MARK: Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency

        settingsTableData = [
            basicItems,
            settingItems
        ]
    }
    
    func cellForSettings(indexPath: IndexPath) -> UITableViewCell {
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
    
    func didSelectRowAt(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                dependency.router.transitionToLisenceView()
            }
        case 1:
            if indexPath.row == 0 {
                // TODO: 言語設定ページ
            } else {
                dependency.router.transitionToRestaurantsSearchSettingsView()
            }
        default:
            break
        }
    }
}

private extension SettingsPresenter {
    // MARK: Private functions
    private func appVersionString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return "\(version).\(build)"
    }
}
