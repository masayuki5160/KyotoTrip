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
    
    // TODO: fix later
    private var busstopLayer: MGLStyleLayer?
    private var busRouteLayer: MGLStyleLayer?
    private let busstopLayerName = "kyoto-busstop"
    private let busRouteLayerName = "kyoto-bus-route"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NavigationBarTitleMap".localized
        busstopButton.layer.cornerRadius = 10.0
        compassButton.layer.cornerRadius = 10.0
        
        mapView.delegate = self
        
        setupVM()
    }
    
    private func setupVM() {
        vm = MapViewModel(mapView: mapView, busstopButtonObservable: busstopButton.rx.tap.asObservable(), compassButtonObservable: compassButton.rx.tap.asObservable())

        vm.busstopButtonStatusObservable.bind { [weak self] (buttonStatus) in
            // TODO: この実装でいいのかあとで確認(VMの責務があってるか確認)
            switch buttonStatus {
            case BusstopButtonStatus.hidden:
                self?.busstopLayer?.isVisible = false
                self?.busRouteLayer?.isVisible = false
            case BusstopButtonStatus.busstop:
                self?.busstopLayer?.isVisible = true
                self?.busRouteLayer?.isVisible = false
            case BusstopButtonStatus.routeAndBusstop:
                self?.busstopLayer?.isVisible = true
                self?.busRouteLayer?.isVisible = true
            }
        }.disposed(by: disposeBag)
    }
    
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        busstopLayer = style.layer(withIdentifier: busstopLayerName)
        busRouteLayer = style.layer(withIdentifier: busRouteLayerName)
        
        // Init busstop and bus route layers
        self.busstopLayer?.isVisible = false
        self.busRouteLayer?.isVisible = false
    }
}
