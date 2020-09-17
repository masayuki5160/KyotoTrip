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
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        indicator.hidesWhenStopped = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.presenter.fetch()
        indicator.startAnimating()
    }

    private func setupTableView() {
        self.navigationItem.title = "NavigationBarTitleInfo".localized
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: infoCellId)

        dependency.presenter.infoDriver
            .drive(tableView.rx.items(
                cellIdentifier: infoCellId,
                cellType: UITableViewCell.self
            )) { [weak self] _, element, cell in
                guard let self = self else { return }
                if self.indicator.isAnimating {
                    self.indicator.stopAnimating()
                }

                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = element.publishDateForCellView
                cell.textLabel?.numberOfLines = 0
                cell.accessoryType = .disclosureIndicator
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            self?.dependency.presenter.didSelectRowAt(indexPath: indexPath)
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

    }
}

extension InfoViewController: DependencyInjectable {
    func inject(_ dependency: InfoViewController.Dependency) {
        self.dependency = dependency
    }
}
