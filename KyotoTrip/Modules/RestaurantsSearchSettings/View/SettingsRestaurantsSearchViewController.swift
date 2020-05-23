//
//  SettingsRestaurantsSearchViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsRestaurantsSearchViewController: UIViewController {

    struct Dependency {
        let presenter: RestaurantsSearchSettingsPresenterProtocol
    }
    private var dependency: Dependency!

    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        dependency.presenter.restaurantsSearchSettingsRowsDriver
            .drive(tableView.rx.items) { tableView, row, element in
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
        
        dependency.presenter.bindRestauransSearchSettingsView(
            input: RestauransSearchSettingsView(selectedCellEntity: tableView.rx.modelSelected(RestaurantsSearchSettingCellEntity.self).asDriver()
            )
        )
        
        navigationItem.title = "飲食店検索設定"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dependency.presenter.saveRestaurantsSettings()
    }
}

extension SettingsRestaurantsSearchViewController: DependencyInjectable {
    func inject(_ dependency: SettingsRestaurantsSearchViewController.Dependency) {
        self.dependency = dependency
    }
}
