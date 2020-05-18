//
//  SettingsRestaurantsSearchViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class SettingsRestaurantsSearchViewController: UIViewController {

    struct Dependency {
        let presenter: AppSettingsPresenterProtocol
    }
    private var dependency: Dependency!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: SettingsTableViewCellWithSwitch.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCellWithSwitch.id)
        tableView.register(UINib(nibName: SettingsTableViewCellWithCurrentParam.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCellWithCurrentParam.id)
        
        navigationItem.title = "飲食店検索設定"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let indexPaths = tableView.indexPathsForVisibleRows ?? []
        dependency.presenter.saveRestaurantsSettings(tableView, indexPaths)
    }
}

extension SettingsRestaurantsSearchViewController: UITableViewDelegate {
}

extension SettingsRestaurantsSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.presenter.restaurantsSearchSettingsTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dependency.presenter.cellForRestaurantsSearchSettings(tableView, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:// Search range setting cell
            let vc = AppDefaultDependencies().assembleSettingsRestaurantsSearchRangeModule()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsRestaurantsSearchViewController: DependencyInjectable {
    func inject(_ dependency: SettingsRestaurantsSearchViewController.Dependency) {
        self.dependency = dependency
    }
}
