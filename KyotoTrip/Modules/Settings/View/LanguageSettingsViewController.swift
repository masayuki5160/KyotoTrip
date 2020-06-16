//
//  LanguageSettingsViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguageSettingsViewController: UIViewController {

    struct Dependency {
        let presenter: LanguageSettingsPresenterProtocol
    }

    @IBOutlet private weak var tableView: UITableView!
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        dependency.presenter.languagesDriver.drive(tableView.rx.items) { _, _, viewData in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "LanguagesCell")
            cell.textLabel?.text = viewData.title
            cell.accessoryType = viewData.isSelect ? .checkmark : .none
            return cell
        }.disposed(by: disposeBag)

        dependency.presenter.bindView(input: .init(
            selectedCell: tableView.rx.modelSelected(LanguageSettingsCellViewData.self).asDriver()
            )
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dependency.presenter.saveSettings()
    }
}

extension LanguageSettingsViewController: DependencyInjectable {
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
}
