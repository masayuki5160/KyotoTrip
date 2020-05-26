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
import FloatingPanel

class MapViewController: UIViewController, TransitionerProtocol {
    
    struct Dependency {
        let presenter: MapPresenterProtocol
    }
    
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var compassButton: UIButton!

    private let visibleFeatures = BehaviorRelay<[MGLFeature]>(value: [])
    private let disposeBag = DisposeBag()
    private var dependency: Dependency!
    private var floatingPanelController: FloatingPanelController!
    private var currentVisibleLayer: MarkerCategory = .None
    private var visibleFeatureForTappedCalloutView: MarkerEntityProtocol? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindPresenter()
        setupCategorySemiModalView()
    }
}

private extension MapViewController {
    private func setupUI() {
        self.navigationItem.title = "NavigationBarTitleMap".localized
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "NavigationBarItemBack".localized, style: .plain, target: nil, action: nil)

        compassButton.layer.cornerRadius = 10.0
        
        mapView.delegate = self
        mapView.setup()
        
        // Add single tap gesture to mapView
        let singleTap = UITapGestureRecognizer()
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        singleTap.rx.event.asDriver().drive(onNext: { [weak self] (gesture) in
            self?.handleMapTap(sender: gesture)
        }).disposed(by: disposeBag)
    }
    
    private func bindPresenter() {
        
        // MARK: Bind to Presenter
        
        dependency.presenter.bindMapView(input: MapViewInput(
            compassButton: compassButton.rx.tap.asDriver(),
            features: visibleFeatures.asDriver(),
            mapView: mapView
            )
        )

        // MARK: Subscribe from Presenter
        
        dependency.presenter.markersDriver
            .drive(onNext: { [weak self] (visibleLayer, annotations) in
                guard let self = self else { return }
            
                self.currentVisibleLayer = visibleLayer.visibleCategory()
            
                self.updateBusstopLayer(visibleLayer.busstop)
                self.updateCulturalPropertyLayer(visibleLayer.culturalProperty)
            
                // FIXME: This is temporaly implementation. If there is a delegate method that is telling when the mapview layer visibility property was changed, use it.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.updateVisibleFeatures()
                }
                
                self.updateRestaurantLayer(visibleStatus:visibleLayer.restaurant, annotations: annotations)
            }).disposed(by: disposeBag)
        
        dependency.presenter.userPositionButtonStatusDriver
            .drive(onNext: { [weak self] (compassButtonStatus) in
            guard let self = self else { return }

            self.updateMapCenterPosition(compassButtonStatus)
            }).disposed(by: disposeBag)
        
        dependency.presenter.selectedCategoryViewCellDriver
            .drive(onNext: { [weak self] feature in
                // FIXME: 初回起動時なイベントを購読する不具合回避
                if feature.title.isEmpty {
                    return
                }

                // move camera position to the annotation position
                let camera = MGLMapCamera(lookingAtCenter: feature.coordinate, altitude: 4500, pitch: 0, heading: 0)
                self?.mapView.fly(to: camera, withDuration: 3, completionHandler: { [weak self] in
                    self?.updateVisibleFeatures()
                })

                self?.showCallout(from: feature)
            }).disposed(by: disposeBag)
    }
    
    private func setupCategorySemiModalView() {
        let categoryViewController = AppDefaultDependencies().assembleCategoryModule()

        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.set(contentViewController: categoryViewController)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    private func updateBusstopLayer(_ visibleStatus: MarkerCategoryEntity.Status) {
        switch visibleStatus {
        case .hidden:
            self.mapView.busstopLayer?.isVisible = false
        case .visible:
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
            self.mapView.busstopLayer?.isVisible = true
        }
    }
    
    private func updateCulturalPropertyLayer(_ visibleStatus: MarkerCategoryEntity.Status) {
        switch visibleStatus {
        case .hidden:
            self.mapView.culturalPropertyLayer?.isVisible = false
        case .visible:
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
            self.mapView.culturalPropertyLayer?.isVisible = true
        }
    }

    private func updateRestaurantLayer(visibleStatus: MarkerCategoryEntity.Status, annotations: [MGLPointAnnotation]) {
        switch visibleStatus {
        case .hidden:
            if let selectedAnnotation = mapView.selectedAnnotations.first {
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
            }

            if let visibleAnnotations = mapView.visibleAnnotations {
                mapView.removeAnnotations(visibleAnnotations)
            }
        case .visible:
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
            mapView.addAnnotations(annotations)
        }
    }
    
    private func updateVisibleFeatures() {
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        var layers: Set<String> = []
        
        if let busstopLayer = mapView.busstopLayer, busstopLayer.isVisible {
            layers.insert(BusstopMarkerEntity.layerId)
        }
        if let culturalPropertyLayer = mapView.culturalPropertyLayer, culturalPropertyLayer.isVisible {
            layers.insert(CulturalPropertyMarkerEntity.layerId)
        }
                
        let features = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: layers)
        visibleFeatures.accept(features)
    }
    
    private func updateMapCenterPosition(_ compassButtonStatus: UserPosition) {
        let clLocationCoordinate2D = CLLocationCoordinate2DMake(
            MapView.kyotoStationLat,
            MapView.kyotoStationLong)
        
        switch compassButtonStatus {
        case .kyotoCity:
            mapView.setCenter(clLocationCoordinate2D, animated: true)
        case .currentLocation:
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        }
    }
    
    private func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Try matching the exact point first.
            let point = sender.location(in: sender.view!)
            for feature in mapView.visibleFeatures(at: point, styleLayerIdentifiers: MapPresenter.layerIdentifiers) where feature is MGLPointFeature {
                guard let selectedFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                
                showCallout(feature: selectedFeature)
                return
            }

            // Select the closest feature to the touch center.
            let closestFeatures = searchClosestFeature(sender)
            if let feature = closestFeatures.first {
                guard let closestFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                showCallout(feature: closestFeature)
                return
            }
            
            // If no features were found, deselect the selected annotation, if any.
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        }
    }
    
    private func searchClosestFeature(_ sender: UITapGestureRecognizer) -> [MGLFeature] {
        let point = sender.location(in: sender.view!)
        let touchCoordinate = mapView.convert(point, toCoordinateFrom: sender.view!)
        let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        
        // Get all features within a rect the size of a touch (44x44).
        let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
        let possibleFeatures = mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: Set(MapPresenter.layerIdentifiers)).filter { $0 is MGLPointFeature }
        
        // Select the closest feature to the touch center.
        let closestFeatures = dependency.presenter.sorteFeatures(features: possibleFeatures, center: touchLocation)

        return closestFeatures
    }
    
    private func showCallout(feature: MGLPointFeature) {
        let markerEntity = dependency.presenter.convertMGLFeatureToMarkerEntity(source: feature)
        showCallout(from: markerEntity)
    }
    
    private func showCallout(from visibleFeature: MarkerEntityProtocol) {
        visibleFeatureForTappedCalloutView = visibleFeature

        let selectedAnnotation = MGLPointFeature()
        selectedAnnotation.title = visibleFeature.title
        selectedAnnotation.subtitle = visibleFeature.subtitle
        selectedAnnotation.coordinate = visibleFeature.coordinate
        
        mapView.selectAnnotation(selectedAnnotation, animated: true, completionHandler: nil)
    }
}

extension MapViewController: DependencyInjectable {
    func inject(_ dependency: MapViewController.Dependency) {
        self.dependency = dependency
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let kyotoMapView = mapView as! MapView
        kyotoMapView.busstopLayer = style.layer(withIdentifier: BusstopMarkerEntity.layerId)
        kyotoMapView.busRouteLayer = style.layer(withIdentifier: BusRouteMarkerEntity.layerId)
        kyotoMapView.culturalPropertyLayer = style.layer(withIdentifier: CulturalPropertyMarkerEntity.layerId)
        
        // Init visible layers
        kyotoMapView.busstopLayer?.isVisible = false
        kyotoMapView.busRouteLayer?.isVisible = false
        kyotoMapView.culturalPropertyLayer?.isVisible = false
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }

    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        mapView.removeAnnotations([annotation])
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        var viewController: DetailViewProtocol

        switch currentVisibleLayer {
        case .Busstop:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule() as! BusstopDetailViewController
            viewController.visibleFeatureEntity = visibleFeatureForTappedCalloutView
        case .CulturalProperty:
            viewController = AppDefaultDependencies().assembleCulturalPropertyDetailModule() as! CulturalPropertyDetailViewController
            viewController.visibleFeatureEntity = visibleFeatureForTappedCalloutView
        case .Restaurant:
            viewController = AppDefaultDependencies().assembleRestaurantDetailModule() as! RestaurantDetailViewController
            let restaurantAnnotation = annotation as! RestaurantPointAnnotation
            viewController.visibleFeatureEntity = restaurantAnnotation.entity
        default:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule() as! BusstopDetailViewController
            viewController.visibleFeatureEntity = visibleFeatureForTappedCalloutView
        }
        self.navigationController?.pushViewController(viewController as! UIViewController, animated: true)
    }
}
