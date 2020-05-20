//
//  SettingsRestaurantSearchRangeViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class SettingsRestaurantsSearchRangeViewController: UIViewController {

    struct Dependency {
        let presenter: AppSettingsPresenterProtocol
    }
    private var dependency: Dependency!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "飲食店検索範囲設定"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // TODO: Move to Presenter and do not call gateway in View
        let requestParamGateway = RestaurantsRequestParamGateway()
        var settings = requestParamGateway.fetch()
        for cell in tableView.visibleCells {
            if cell.accessoryType == .checkmark {
                switch cell.textLabel?.text {
                case "300m":
                    settings.range = .range300
                case "500m":
                    settings.range = .range500
                case "1000m":
                    settings.range = .range1000
                case "2000m":
                    settings.range = .range2000
                case "3000m":
                    settings.range = .range3000
                default:
                    break
                }
            }
        }
        
        requestParamGateway.save(entity: settings)
    }
}

extension SettingsRestaurantsSearchRangeViewController: UITableViewDelegate {
}

extension SettingsRestaurantsSearchRangeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.presenter.restaurantsSearchRangeSettingsTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "restaurantsSearchRange")
        cell.textLabel?.text = dependency.presenter.restaurantsSearchRangeSettingsTableData[indexPath.row]

        // TODO: Move to Presenter and do not call gateway in View
        let requestParamGateway = RestaurantsRequestParamGateway()
        let settings = requestParamGateway.fetch()
        if cell.textLabel?.text == settings.rangeStr {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for cursorIndexPath in indexPaths {// TODO: 変数名を修正する
                if cursorIndexPath.row == indexPath.row {
                    continue
                }

                tableView.cellForRow(at: cursorIndexPath)?.accessoryType = .none
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsRestaurantsSearchRangeViewController: DependencyInjectable {
    func inject(_ dependency: SettingsRestaurantsSearchRangeViewController.Dependency) {
        self.dependency = dependency
    }
}
