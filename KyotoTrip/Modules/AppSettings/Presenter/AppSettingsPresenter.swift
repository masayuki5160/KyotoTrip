//
//  AppSettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import UIKit

protocol AppSettingsPresenterProtocol {
    func cellForSettings(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell/// TODO: SettingViewControllerをリファクタしたら削除?
    var settingsTableSectionTitle: [String] { get }/// TODO: SettingViewControllerをリファクタしたら削除?
    var settingsTableData: [[String]] { get }/// TODO: SettingViewControllerをリファクタしたら削除
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
}

private extension AppSettingsPresenter {
    // MARK: Private functions
    private func appVersionString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return "\(version).\(build)"
    }
}
