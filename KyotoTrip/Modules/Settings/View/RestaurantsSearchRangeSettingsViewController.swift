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

class RestaurantsSearchRangeSettingsViewController: UIViewController, TransitionerProtocol {

    struct Dependency {
        let presenter: RestaurantsSearchRangeSettingPresenterProtocol
    }
    private var dependency: Dependency!
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "飲食店検索範囲設定"
        
        dependency.presenter.bindView(input:
            RestauransSearchRangeSettingView(
                selectedCellEntity: tableView.rx.modelSelected(RestaurantsSearchRangeCellViewData.self).asDriver()
            )
        )
        
        dependency.presenter.searchRangeRowsDriver
            .drive(tableView.rx.items) { tableView, row, element in
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
