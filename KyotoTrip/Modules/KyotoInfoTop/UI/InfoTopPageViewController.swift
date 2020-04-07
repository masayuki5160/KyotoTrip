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
    
    // TODO: 依存関係の構築はあとで整理する
    private var presenter: KyotoCityInfoPresenterProtocol!
    private var usecase: KyotoCityInfoUseCase!
    private var gateway: KyotoCityInfoGateway!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NavigationBarTitleInfo".localized
        
        // TODO: 依存関係の構築はここでやるべきではないはずなので修正
        usecase = KyotoCityInfoUseCase()
        presenter = KyotoCityInfoPresenter(useCase: usecase)
        gateway = KyotoCityInfoGateway()
        usecase.kyotoCityInfoGateway = gateway
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(UINib(nibName: "InfoTopPageTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTopPageTableViewCell")

        usecase.fetch()
        
        presenter.subscribableModelList.bind(to: tableView.rx.items(cellIdentifier: "InfoTopPageTableViewCell", cellType: InfoTopPageTableViewCell.self)) { row, element, cell in
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
