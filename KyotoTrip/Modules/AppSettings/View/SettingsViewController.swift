//
//  SettingsViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/16.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let sectionList = ["基本設定", "言語設定", "飲食店検索設定"]

    private let basicItems: [String] = ["ヘルプ", "ライセンス"]
    private let languageItems: [String] = ["日本語"]
    private let restaurantItems: [String] = ["検索範囲", "英語スタッフ", "韓国語スタッフ", "中国語スタッフ", "ベジタリアンメニュー", "クレジットカード", "個室", "Wifi", "禁煙"]
    
    struct Dependency {
    }
    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "SettingsPageTitle".localized
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: SettingsTableViewCell.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.id)
        tableView.register(UINib(nibName: SettingTableViewCellWithSwitch.id, bundle: nil), forCellReuseIdentifier: SettingTableViewCellWithSwitch.id)
        tableView.register(UINib(nibName: SettingTableViewCellWithCurrentParam.id, bundle: nil), forCellReuseIdentifier: SettingTableViewCellWithCurrentParam.id)
    }
}

extension SettingsViewController: UITableViewDelegate {
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return basicItems.count
        case 1:
            return languageItems.count
        case 2:
            return restaurantItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.id, for: indexPath) as! SettingsTableViewCell
            cell.title.text = basicItems[indexPath.row]
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.id, for: indexPath) as! SettingsTableViewCell
            cell.title.text = languageItems[indexPath.row]
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

            return cell
        case 2:
            // TODO: 現在の検索設定を読み込んで反映させる
            let restaurantSearchSettings = RestaurantsRequestParamEntity()
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellWithCurrentParam.id, for: indexPath) as! SettingTableViewCellWithCurrentParam
                cell.title.text = restaurantItems[indexPath.row]
                cell.currentParam.text = restaurantSearchSettings.rangeStr
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellWithSwitch.id, for: indexPath) as! SettingTableViewCellWithSwitch
                cell.title.text = restaurantItems[indexPath.row]
                
                return cell
            }
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            cell.title.text = "none"

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("did select row in section 0")
        case 1:
            print("did select row in section 1")
        case 2:
            print("did select row in section 2")
        default:
            print("default")
        }
    }

}

extension SettingsViewController: DependencyInjectable {
    func inject(_ dependency: SettingsViewController.Dependency) {
        self.dependency = dependency
    }
}
