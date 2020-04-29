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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var testCategoryButton: UIButton!
    
    struct Dependency {
        let presenter: KyotoMapPresenterProtocol
    }
    
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        
        dependency.presenter.bindCategoryButtonTapEvent(button: testCategoryButton.rx.tap.asObservable())
        dependency.presenter.visibleFeatureDriver.drive(onNext: { [weak self] (features) in
            print("test CategoryViewController")
            print(features)
        }).disposed(by: disposeBag)
    }
}

extension CategoryViewController: DependencyInjectable {
    func inject(_ dependency: CategoryViewController.Dependency) {
        self.dependency = dependency
    }
}
