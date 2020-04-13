//
//  InfoTopPageViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import SafariServices
import RxSwift
import RxCocoa
import SafariServices// TODO: Use WKWebView

class InfoTopPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var disposeBag = DisposeBag()
        
    struct Dependency {
        let presenter: KyotoCityInfoPresenter
    }
    private var dependency: Dependency!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
        
    private func setupTableView() {

        self.navigationItem.title = "NavigationBarTitleInfo".localized

        tableView.register(UINib(nibName: "InfoTopPageTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTopPageTableViewCell")
        
        dependency.presenter.fetch()// TODO: fetchはここでいいのか確認
        dependency.presenter.subscribableModelList.bind(to: tableView.rx.items(cellIdentifier: "InfoTopPageTableViewCell", cellType: InfoTopPageTableViewCell.self)) { row, element, cell in
            cell.title.text = element.title// TODO: デフォルト値を空文字にしておけば良さそう、見せ方は調整
            cell.publishDate.text = element.publishDate
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(KyotoCityInfo.self)
            .map{ URL(string: $0.link) }
            .subscribe(onNext: { [weak self] (url) in
                guard let self = self, let url = url else { return }
                self.present(SFSafariViewController(url: url), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
    }
}

extension InfoTopPageViewController: DependencyInjectable {
    func inject(_ dependency: InfoTopPageViewController.Dependency) {
        self.dependency = dependency
    }
}
