//
//  CulturalPropertyDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class CulturalPropertyDetailViewController: UIViewController {
    
    struct Dependency {
        let presenter: CulturalPropertyDetailPresenterProtocol
    }
    
    private var dependency: Dependency!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CulturalPropertyDetailViewController: DependencyInjectable {
    func inject(_ dependency: CulturalPropertyDetailViewController.Dependency) {
        self.dependency = dependency
    }
}

extension CulturalPropertyDetailViewController: UITableViewDelegate {
}

extension CulturalPropertyDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dependency.presenter.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dependency.presenter.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dependency.presenter.createCellForRowAt(indexPath: indexPath)
    }
}
