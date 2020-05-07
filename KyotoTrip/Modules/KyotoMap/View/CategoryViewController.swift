//
//  CategoryViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/29.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var culturalPropertyButton: UIButton!
    @IBOutlet weak var busstopButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    
    struct Dependency {
        let presenter: KyotoMapPresenterProtocol
    }
    
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuUI()
        bindPresenter()
    }
}

// MARK: - Private functions

private extension CategoryViewController {
    private func setuUI() {
        // TODO: アイコンが見えにくいためCategoryViewControllerについてはダークモードOFFとする
        self.overrideUserInterfaceStyle = .light
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }
    
    private func bindPresenter() {
        dependency.presenter.bindCategoryView(input: CategoryViewInput(
            culturalPropertyButton: culturalPropertyButton.rx.tap.asDriver(),
            infoButton: infoButton.rx.tap.asDriver(),
            busstopButton: busstopButton.rx.tap.asDriver(),
            restaurantButton: restaurantButton.rx.tap.asDriver(),
            tableViewCell: tableView.rx.modelSelected(VisibleFeatureProtocol.self).asDriver()
            )
        )
        
        let combineLatestFeatures = Driver.combineLatest(
            dependency.presenter.visibleFeatureDriver,
            dependency.presenter.visibleFeatureRestaurantDriver
        ) { $0 + $1 }

        combineLatestFeatures.drive(tableView.rx.items(cellIdentifier: "CategoryTableViewCell", cellType: CategoryTableViewCell.self)) { row, element, cell in
                cell.title.text = element.title
                switch element.type {
                case .Busstop:
                    cell.icon.image = UIImage(named: "icons8-bus-80")
                case .CulturalProperty:
                    cell.icon.image = UIImage(named: "icons8-torii-48")
                case .Restaurant:
                    cell.icon.image = UIImage(named: "icons8-restaurant-100")
                default:
                    cell.icon.image = UIImage()
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - Other extension

extension CategoryViewController: DependencyInjectable {
    func inject(_ dependency: CategoryViewController.Dependency) {
        self.dependency = dependency
    }
}
