//
//  MapViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import Mapbox
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var busstopButton: UIButton!
    @IBOutlet weak var compassButton: UIButton!
    
    
    private var vm: MapViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NavigationBarTitleMap".localized
        busstopButton.layer.cornerRadius = 10.0
        compassButton.layer.cornerRadius = 10.0
        
        setupVM()
    }
    
    private func setupVM() {
        vm = MapViewModel(mapView: mapView, busstopButtonObservable: busstopButton.rx.tap.asObservable(), compassButtonObservable: compassButton.rx.tap.asObservable())

        vm.busstopButtonStatusObservable.bind { (buttonStatus) in
            // TODO: この実装でいいのかあとで確認(VMの責務があってるか確認)
            // TODO: ステータスに応じて地図のレイヤーの表示非表示対応をする
            switch buttonStatus {
            case BusstopButtonStatus.hidden:
                print("test1")
            case BusstopButtonStatus.busstop:
                print("test2")
            case BusstopButtonStatus.routeAndBusstop:
                print("test3")
            }
        }.disposed(by: disposeBag)
    }
    
}

extension MapViewController: MGLMapViewDelegate {
    
}
