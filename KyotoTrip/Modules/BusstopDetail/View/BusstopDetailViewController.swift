//
//  BusstopDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/22.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class BusstopDetailViewController: UIViewController, TransitionerProtocol {
    struct Dependency {
        let presenter: BusstopDetailPresenterProtocol
    }

    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "BusstopDetailTitle".localized
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension BusstopDetailViewController: UITableViewDataSource {
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

extension BusstopDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dependency.presenter.didSelectRowAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BusstopDetailViewController: DependencyInjectable {
    func inject(_ dependency: BusstopDetailViewController.Dependency) {
        self.dependency = dependency
    }
}
