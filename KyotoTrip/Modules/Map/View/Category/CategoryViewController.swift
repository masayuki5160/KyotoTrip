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

class CategoryViewController: UIViewController, TransitionerProtocol {
    
    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var culturalPropertyButton: UIButton!
    @IBOutlet weak var busstopButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    
    struct Dependency {
        let presenter: CategoryPresenterProtocol
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
        tableView.register(UINib(nibName: CategoryTableViewCell.id, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.id)
    }
    
    private func bindPresenter() {
        dependency.presenter.bindCategoryView(input: CategoryViewInput(
            culturalPropertyButton: culturalPropertyButton.rx.tap.asSignal(),
            busstopButton: busstopButton.rx.tap.asSignal(),
            restaurantButton: restaurantButton.rx.tap.asSignal(),
            selectedCell: tableView.rx.modelSelected(CategoryCellViewData.self).asSignal()
            )
        )
        
        dependency.presenter.cellsDriver.drive(tableView.rx.items(cellIdentifier: CategoryTableViewCell.id, cellType: CategoryTableViewCell.self))
        { row, element, cell in
            cell.title.text = element.title
            let iconName = element.iconName
            cell.icon.image = UIImage(named: iconName)
        }.disposed(by: disposeBag)
    }
}

// MARK: - Other extension

extension CategoryViewController: DependencyInjectable {
    func inject(_ dependency: CategoryViewController.Dependency) {
        self.dependency = dependency
    }
}
