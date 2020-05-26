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

    private let mglFeatures = BehaviorRelay<[MGLFeature]>(value: [])
    private let disposeBag = DisposeBag()
    private var dependency: Dependency!
    private var floatingPanelController: FloatingPanelController!

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
            mglFeatures: mglFeatures.asDriver(),
            mapView: mapView
            )
        )

        // MARK: Subscribe from Presenter
        
        dependency.presenter.markersDriver
            .drive(onNext: { [weak self] (markerCategory, restaurantAnnotations) in
                guard let self = self else { return }
            
                self.mapView.visibleMarkerCategory = markerCategory.visibleCategory()
            
                self.updateMarkersOnStyleLayers()
                self.updateRestaurantMarkers(annotations: restaurantAnnotations)
            }).disposed(by: disposeBag)
        
        dependency.presenter.userPositionButtonStatusDriver
            .drive(onNext: { [weak self] (compassButtonStatus) in
            guard let self = self else { return }

            self.updateMapCenterPosition(compassButtonStatus)
            }).disposed(by: disposeBag)
        
        dependency.presenter.selectedCategoryViewCellDriver
            .drive(onNext: { [weak self] markerEntity in
                if markerEntity.title.isEmpty { return }

                // move camera position to the annotation position
                let camera = MGLMapCamera(lookingAtCenter: markerEntity.coordinate, altitude: 4500, pitch: 0, heading: 0)
                self?.mapView.fly(to: camera, withDuration: 3, completionHandler: nil)
                self?.showCallout(from: markerEntity)
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

    private func updateRestaurantMarkers(annotations: [MGLPointAnnotation]) {
        if mapView.visibleMarkerCategory == .Restaurant {
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
            mapView.addAnnotations(annotations)
        } else {
            if let selectedAnnotation = mapView.selectedAnnotations.first {
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
            }

            if let visibleAnnotations = mapView.visibleAnnotations {
                mapView.removeAnnotations(visibleAnnotations)
            }
        }
    }
    
    private func updateMarkersOnStyleLayers() {
        updateBusstopLayer()
        updateCulturalPropertyLayer()

        // Note:
        // Wait for updating Style Layers, then fetch the MGLFeatures from Style Layers and relay to other modules
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            var layers: Set<String> = []
            
            if let busstopLayer = self.mapView.busstopLayer, busstopLayer.isVisible {
                layers.insert(BusstopMarkerEntity.layerId)
            }
            if let culturalPropertyLayer = self.mapView.culturalPropertyLayer, culturalPropertyLayer.isVisible {
                layers.insert(CulturalPropertyMarkerEntity.layerId)
            }
            
            /// Get features from Style Layers which is defined in Mapbox Studio
            let features = self.mapView.visibleFeatures(in: rect, styleLayerIdentifiers: layers)
            self.mglFeatures.accept(features)
        }
    }
    
    private func updateBusstopLayer() {
        if mapView.visibleMarkerCategory == .Busstop {
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
            self.mapView.busstopLayer?.isVisible = true
        } else {
            self.mapView.busstopLayer?.isVisible = false
        }
    }
    
    private func updateCulturalPropertyLayer() {
        if mapView.visibleMarkerCategory == .CulturalProperty {
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
            self.mapView.culturalPropertyLayer?.isVisible = true
        } else {
            self.mapView.culturalPropertyLayer?.isVisible = false
        }
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
        let closestFeatures = dependency.presenter.sorteMGLFeatures(features: possibleFeatures, center: touchLocation)

        return closestFeatures
    }
    
    private func showCallout(feature: MGLPointFeature) {
        let markerEntity = dependency.presenter.convertMGLFeatureToMarkerEntity(source: feature)
        showCallout(from: markerEntity)
    }
    
    private func showCallout(from entity: MarkerEntityProtocol) {
        let selectedAnnotation = CustomMGLPointAnnotation(entity: entity)
        selectedAnnotation.title = entity.title
        selectedAnnotation.subtitle = entity.subtitle
        selectedAnnotation.coordinate = entity.coordinate
        
        // Show callout
        mapView.selectAnnotation(selectedAnnotation, animated: true, completionHandler: nil)
    }
}

extension MapViewController: DependencyInjectable {
    func inject(_ dependency: MapViewController.Dependency) {
        self.dependency = dependency
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
        let tappedCalloutCategory = (mapView as! MapView).visibleMarkerCategory
        let entity = (annotation as! CustomMGLPointAnnotation).entity

        // TODO: Move to MapPresenter
        switch tappedCalloutCategory {
        case .Busstop:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule() as! BusstopDetailViewController
        case .CulturalProperty:
            viewController = AppDefaultDependencies().assembleCulturalPropertyDetailModule() as! CulturalPropertyDetailViewController
        case .Restaurant:
            viewController = AppDefaultDependencies().assembleRestaurantDetailModule() as! RestaurantDetailViewController
        default:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule() as! BusstopDetailViewController
        }
        
        viewController.visibleFeatureEntity = entity
        self.navigationController?.pushViewController(viewController as! UIViewController, animated: true)
    }
}
