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

class InfoTopPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var vm = KyotoCityInfoViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NavigationBarTitleInfo".localized
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "InfoTopPageTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTopPageTableViewCell")

        vm.subscribableModelList.bind(to: tableView.rx.items(cellIdentifier: "InfoTopPageTableViewCell", cellType: InfoTopPageTableViewCell.self)) { row, element, cell in
            cell.title.text = element.title
            cell.publishDate.text = element.publishDate
        }.disposed(by: disposeBag)
        
    }
        
}

// TODO: Rxを使うとUITableViewDelegateをなくせるか確認
extension InfoTopPageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = vm.modelList(index: indexPath.row)

        if let url = URL(string: data.link) {
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        }
    }

}
