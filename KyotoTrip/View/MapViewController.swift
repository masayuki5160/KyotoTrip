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
        vm = MapViewModel(busstopButton: busstopButton.rx.tap.asObservable(), compassButton: compassButton.rx.tap.asObservable())

        vm.busstopButtonStatusDriver.drive(onNext: { [weak self] (buttonStatus) in
            self?.updateBusstopLayer(buttonStatus)
        }).disposed(by: disposeBag)
        
        vm.compassButtonStatusObservable.drive(onNext: { [weak self] (compassButtonStatus) in
            self?.updateMapCenterPosition(compassButtonStatus)
        }).disposed(by: disposeBag)
    }
    
    private func updateBusstopLayer(_ buttonStatus: BusstopButtonStatus) {
        
        switch buttonStatus {
        case BusstopButtonStatus.hidden:
            self.mapView.busstopLayer?.isVisible = false
            self.mapView.busRouteLayer?.isVisible = false
        case BusstopButtonStatus.busstop:
            self.mapView.busstopLayer?.isVisible = true
            self.mapView.busRouteLayer?.isVisible = false
        case BusstopButtonStatus.routeAndBusstop:
            self.mapView.busstopLayer?.isVisible = true
            self.mapView.busRouteLayer?.isVisible = true
        }
        
    }
    
    private func updateMapCenterPosition(_ compassButtonStatus: CompassButtonStatus) {
        
        let clLocationCoordinate2D = CLLocationCoordinate2DMake(
            KyotoMapView.kyotoStationLat,
            KyotoMapView.kyotoStationLong)
        
        switch compassButtonStatus {
        case .kyotoCity:
            self.mapView.setCenter(clLocationCoordinate2D, animated: true)
        case .currentLocation:
            self.mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        }
        
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
