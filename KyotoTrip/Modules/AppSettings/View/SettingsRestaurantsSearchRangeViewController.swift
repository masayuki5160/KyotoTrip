//
//  SettingsRestaurantSearchRangeViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsRestaurantsSearchRangeViewController: UIViewController {

    struct Dependency {
        let presenter: AppSettingsPresenterProtocol
    }
    private var dependency: Dependency!
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "飲食店検索範囲設定"
        
        dependency.presenter.bindRestauransSearchRangeSettingView(input:
            RestauransSearchRangeSettingView(
                selectedCellEntity: tableView.rx.modelSelected(RestaurantsSearchRangeCellEntity.self).asDriver()
            )
        )
        
        dependency.presenter.restaurantsSearchRangeSettingRowsDriver
            .drive(tableView.rx.items) { tableView, row, element in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "restaurantsSearchRange")
                cell.textLabel?.text = element.range
                cell.accessoryType = element.isSelected ? .checkmark : .none

                return cell
        }.disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dependency.presenter.saveRestaurantsSettings()
    }
}

extension SettingsRestaurantsSearchRangeViewController: DependencyInjectable {
    func inject(_ dependency: SettingsRestaurantsSearchRangeViewController.Dependency) {
        self.dependency = dependency
    }
}
