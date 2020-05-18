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
    
    struct Dependency {
        let presenter: AppSettingsPresenterProtocol
    }
    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        self.navigationItem.title = "SettingsPageTitle".localized
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: SettingsTableViewCell.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.id)
        tableView.register(UINib(nibName: SettingsTableViewCellWithSwitch.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCellWithSwitch.id)
        tableView.register(UINib(nibName: SettingsTableViewCellWithCurrentParam.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCellWithCurrentParam.id)
    }
}

extension SettingsViewController: UITableViewDelegate {
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dependency.presenter.settingsTableSectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dependency.presenter.settingsTableSectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.presenter.settingsTableData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dependency.presenter.cellForSettings(tableView, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                let vc = AppDefaultDependencies().assembleSettingsLisenceModule()
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                // TODO: 言語設定ページ
            } else {
                let vc = AppDefaultDependencies().assembleSettingsRestaurantsSearchModule()
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension SettingsViewController: DependencyInjectable {
    func inject(_ dependency: SettingsViewController.Dependency) {
        self.dependency = dependency
    }
}
