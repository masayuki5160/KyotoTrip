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
    @IBOutlet weak var rentalCycleButton: UIButton!
    @IBOutlet weak var cycleParkingButton: UIButton!
    
    
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
            culturalPropertyButton: culturalPropertyButton.rx.tap.asObservable(),
            infoButton: infoButton.rx.tap.asObservable(),
            busstopButton: busstopButton.rx.tap.asObservable(),
            rentalCycleButton: rentalCycleButton.rx.tap.asObservable(),
            cycleParkingButton: cycleParkingButton.rx.tap.asObservable(),
            tableViewCell: tableView.rx.modelSelected(VisibleFeature.self).asObservable()
            )
        )

        dependency.presenter.visibleFeatureDriver.drive(tableView.rx.items(cellIdentifier: "CategoryTableViewCell", cellType: CategoryTableViewCell.self)) { row, element, cell in
            cell.title.text = element.title
        }.disposed(by: disposeBag)
    }
}

// MARK: - Other extension

extension CategoryViewController: DependencyInjectable {
    func inject(_ dependency: CategoryViewController.Dependency) {
        self.dependency = dependency
    }
}
