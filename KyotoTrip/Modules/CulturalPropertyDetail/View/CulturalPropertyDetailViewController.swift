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

    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "都道府県指定文化財"
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
