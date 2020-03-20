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
    @IBOutlet weak var busStopButton: UIButton!
    
    let kyotoStationLat = 34.9857083
    let kyotoStationLong = 135.7560416
    let defaultZoomLv = 13.0
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NavigationBarTitleMap".localized
        
        // TODO: MapViewとbusボタンをVMに移行する方がいいのかも
        mapView.setCenter(CLLocationCoordinate2D(latitude: kyotoStationLat, longitude: kyotoStationLong), zoomLevel: defaultZoomLv, animated: false)
        
        busStopButton.layer.cornerRadius = 10.0
        busStopButton.rx.tap.subscribe { (onNext) in
            print("taped")
            // TODO: ここでバス停の表示ON/OFF + バスルートのON/OFF
        }.disposed(by: disposeBag)
    }
    
}
