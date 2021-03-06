//
//  SettingsRestaurantsSearchViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RestaurantsSearchSettingsViewController: UIViewController, TransitionerProtocol {
    struct Dependency {
        let presenter: RestaurantsSearchSettingsPresenterProtocol
    }

    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        dependency.presenter.settingsRowsDriver.drive(tableView.rx.items) { _, row, element in
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "RestaurantsSearchSettingCell")
            cell.textLabel?.text = element.title
            if row == 0 {// For restaurants search range setting cell
                cell.detailTextLabel?.text = element.detail
                cell.accessoryType = .disclosureIndicator
            } else {// Other cells
                cell.accessoryType = element.isSelected ? .checkmark : .none
            }

            return cell
        }.disposed(by: disposeBag)

        dependency.presenter.bindView(
            input: RestauransSearchSettingsView(
                selectedCell: tableView.rx.modelSelected(RestaurantsSearchSettingsCellViewData.self).asDriver()
            )
        )

        navigationItem.title = "RestaurantSearchSettingsPageNavigationTitle".localized
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.presenter.reloadSettings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.saveSettings()
    }
}

extension RestaurantsSearchSettingsViewController: DependencyInjectable {
    func inject(_ dependency: RestaurantsSearchSettingsViewController.Dependency) {
        self.dependency = dependency
    }
}
