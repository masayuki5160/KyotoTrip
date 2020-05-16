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
    
    // TODO: 設定のパーツを個別に用意する
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: SettingsTableViewCellWithSwitch.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCellWithSwitch.id)
        tableView.register(UINib(nibName: SettingsTableViewCellWithCurrentParam.id, bundle: nil), forCellReuseIdentifier: SettingsTableViewCellWithCurrentParam.id)
        
        navigationItem.title = "飲食店検索設定"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let cells = tableView.visibleCells
        dependency.presenter.saveRestaurantsSettings(cells: cells)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsRestaurantsSearchViewController: DependencyInjectable {
    func inject(_ dependency: SettingsRestaurantsSearchViewController.Dependency) {
        self.dependency = dependency
    }
}
