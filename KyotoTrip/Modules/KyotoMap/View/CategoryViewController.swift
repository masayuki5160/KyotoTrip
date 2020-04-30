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
    @IBOutlet weak var testCategoryButton: UIButton!
    
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
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }
    
    private func bindPresenter() {
        dependency.presenter.bindCategoryButtonTapEvent(button: testCategoryButton.rx.tap.asObservable())

        dependency.presenter.visibleFeatureDriver.drive(tableView.rx.items(cellIdentifier: "CategoryTableViewCell", cellType: CategoryTableViewCell.self)) { row, element, cell in
            cell.title.text = element.title
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(VisibleFeature.self).subscribe(onNext: { feature in
            // TODO: タップしたPOIをマップ上で示す
            print("tapped cell \(feature.title)")
        }).disposed(by: disposeBag)
    }
}

// MARK: - Other extension

extension CategoryViewController: DependencyInjectable {
    func inject(_ dependency: CategoryViewController.Dependency) {
        self.dependency = dependency
    }
}
