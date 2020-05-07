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
    let sectionList = ["basic", "language"]
    
    struct Dependency {
    }
    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "SettingsPageTitle".localized
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
        return cell
    }
    
    
}

extension SettingsViewController: DependencyInjectable {
    func inject(_ dependency: SettingsViewController.Dependency) {
        self.dependency = dependency
    }
}
