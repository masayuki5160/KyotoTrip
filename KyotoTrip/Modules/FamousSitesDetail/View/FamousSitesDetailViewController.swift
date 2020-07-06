//
//  FamousSitesDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/07/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class FamousSitesDetailViewController: UIViewController {

    struct Dependency {
        let presenter: FamousSitesDetailPresenterProtocol
    }

    @IBOutlet private weak var tableView: UITableView!
    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "FamousSitesDetailPage".localized
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FamousSitesDetailViewController: DependencyInjectable {
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
}

extension FamousSitesDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dependency.presenter.didSelectRowAt(tableView: tableView, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FamousSitesDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dependency.presenter.sectionTitles.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dependency.presenter.sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dependency.presenter.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dependency.presenter.createCellForRowAt(indexPath: indexPath)
    }
}
