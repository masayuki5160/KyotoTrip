//
//  InfoViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import SafariServices
import RxCocoa
import RxSwift

class InfoViewController: UIViewController, TransitionerProtocol {
    struct Dependency {
        let presenter: InfoPresenterProtocol
    }

    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!
    private var disposeBag = DisposeBag()
    private let infoCellId = "InfoTableViewCell"
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        dependency.presenter.fetch()
    }

    private func setupTableView() {
        self.navigationItem.title = "NavigationBarTitleInfo".localized
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: infoCellId)

        dependency.presenter.infoDriver.drive(tableView.rx.items(cellIdentifier: infoCellId, cellType: UITableViewCell.self)) { _, element, cell in
            cell.textLabel?.text = element.title
            cell.detailTextLabel?.text = element.publishDateForCellView
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .disclosureIndicator
        }.disposed(by: disposeBag)

        Driver.combineLatest(
            tableView.rx.modelSelected(InfoCellViewData.self).asDriver(),
            tableView.rx.itemSelected.asDriver()
        ).drive(onNext: { [weak self] _, indexPath in
            self?.dependency.presenter.didSelectRowAt(indexPath: indexPath)
            self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        ).disposed(by: disposeBag)
    }
}

extension InfoViewController: DependencyInjectable {
    func inject(_ dependency: InfoViewController.Dependency) {
        self.dependency = dependency
    }
}
