//
//  SettingsViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/16.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import UIKit

class SettingsViewController: UIViewController, TransitionerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Dependency {
        let presenter: SettingsPresenterProtocol
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
        return dependency.presenter.cellForSettings(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dependency.presenter.didSelectRowAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension SettingsViewController: DependencyInjectable {
    func inject(_ dependency: SettingsViewController.Dependency) {
        self.dependency = dependency
    }
}
