//
//  SettingsRestaurantSearchRangeViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RestaurantsSearchRangeSettingsViewController: UIViewController, TransitionerProtocol {
    struct Dependency {
        let presenter: RestaurantsSearchRangeSettingPresenterProtocol
    }

    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "飲食店検索範囲設定"

        dependency.presenter.bindView(
            input: RestauransSearchRangeSettingView(
                selectedCell: tableView.rx.modelSelected(RestaurantsSearchRangeCellViewData.self).asDriver()
            )
        )

        dependency.presenter.searchRangeRowsDriver.drive(tableView.rx.items) { _, _, element in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "restaurantsSearchRange")
            cell.textLabel?.text = element.rangeString
            cell.accessoryType = element.isSelected ? .checkmark : .none

            return cell
        }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.presenter.reloadSettings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dependency.presenter.saveRestaurantsSettings()
    }
}

extension RestaurantsSearchRangeSettingsViewController: DependencyInjectable {
    func inject(_ dependency: RestaurantsSearchRangeSettingsViewController.Dependency) {
        self.dependency = dependency
    }
}
