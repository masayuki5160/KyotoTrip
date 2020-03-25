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
    
    @IBOutlet weak var mapView: KyotoMapView!
    @IBOutlet weak var busstopButton: UIButton!
    @IBOutlet weak var compassButton: UIButton!
    
    
    private var vm: MapViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NavigationBarTitleMap".localized
        busstopButton.layer.cornerRadius = 10.0
        compassButton.layer.cornerRadius = 10.0
        
        mapView.delegate = self
        mapView.setup()

        setupVM()
    }
    
    private func setupVM() {
        vm = MapViewModel(busstopButtonObservable: busstopButton.rx.tap.asObservable(), compassButtonObservable: compassButton.rx.tap.asObservable())

        vm.busstopButtonStatusObservable.bind { [weak self] (buttonStatus) in
            
            // TODO: この実装でいいのかあとで確認(VMの責務があってるか確認)
            switch buttonStatus {
            case BusstopButtonStatus.hidden:
                self?.mapView.busstopLayer?.isVisible = false
                self?.mapView.busRouteLayer?.isVisible = false
            case BusstopButtonStatus.busstop:
                self?.mapView.busstopLayer?.isVisible = true
                self?.mapView.busRouteLayer?.isVisible = false
            case BusstopButtonStatus.routeAndBusstop:
                self?.mapView.busstopLayer?.isVisible = true
                self?.mapView.busRouteLayer?.isVisible = true
            }
            
        }.disposed(by: disposeBag)
        
        vm.compassButtonStatusObservable.bind { [weak self] (compassButtonStatus) in
            
            let clLocationCoordinate2D = CLLocationCoordinate2DMake(KyotoMapView.kyotoStationLat, KyotoMapView.kyotoStationLong)
            
            switch compassButtonStatus {
            case .kyotoCity:
                self?.mapView.setCenter(clLocationCoordinate2D, animated: true)
            case .currentLocation:
                self?.mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
            }
            
        }.disposed(by: disposeBag)
    }
    
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        self.mapView.busstopLayer = style.layer(withIdentifier: self.mapView.busstopLayerName)
        self.mapView.busRouteLayer = style.layer(withIdentifier: self.mapView.busRouteLayerName)
        
        // Init busstop and bus route layers
        self.mapView.busstopLayer?.isVisible = false
        self.mapView.busRouteLayer?.isVisible = false
    }
}
