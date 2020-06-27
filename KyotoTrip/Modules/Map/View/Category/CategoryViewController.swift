//
//  CategoryViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/29.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CategoryViewController: UIViewController, TransitionerProtocol {
    struct Dependency {
        let presenter: CategoryPresenterProtocol
    }

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var culturalPropertyButton: UIButton!
    @IBOutlet private weak var busstopButton: UIButton!
    @IBOutlet private weak var restaurantButton: UIButton!
    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let cellId = "CategoryTableViewCell"

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
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    private func bindPresenter() {
        dependency.presenter.bindCategoryView(
            input: CategoryViewInput(
                culturalPropertyButton: culturalPropertyButton.rx.tap.asSignal(),
                busstopButton: busstopButton.rx.tap.asSignal(),
                restaurantButton: restaurantButton.rx.tap.asSignal(),
                selectedCell: tableView.rx.modelSelected(CategoryCellViewData.self).asSignal()
            )
        )

        dependency.presenter.cellsDriver.drive(
            tableView.rx.items(cellIdentifier: cellId, cellType: UITableViewCell.self)
        ) { _, element, cell in
            cell.textLabel?.text = element.title
            cell.imageView?.image = UIImage(named: element.iconName)
            cell.accessoryType = .disclosureIndicator
        }.disposed(by: disposeBag)
    }
}

// MARK: - Other extension

extension CategoryViewController: DependencyInjectable {
    func inject(_ dependency: CategoryViewController.Dependency) {
        self.dependency = dependency
    }
}
