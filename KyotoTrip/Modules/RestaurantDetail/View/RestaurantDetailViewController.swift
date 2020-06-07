//
//  RestaurantDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    struct Dependency {
        let presenter: RestaurantDetailPresenterProtocol
    }

    @IBOutlet private weak var tableView: UITableView!
    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "飲食店詳細"
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension RestaurantDetailViewController: DependencyInjectable {
    func inject(_ dependency: RestaurantDetailViewController.Dependency) {
        self.dependency = dependency
    }
}

extension RestaurantDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dependency.presenter.didSelectRowAt(tableView: tableView, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RestaurantDetailViewController: UITableViewDataSource {
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
