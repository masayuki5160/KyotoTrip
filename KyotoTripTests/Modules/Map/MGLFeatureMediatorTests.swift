//
//  MGLFeatureMediatorTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/06.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip
import RxSwift
import RxCocoa
import CoreLocation
import Mapbox.MGLFeature

class MGLFeatureMediatorTests: XCTestCase {
    
    var interactor: MapInteractorStub!
    var presenter: MapPresenter!
    var view: MapViewController!
    var mediator: MGLFeatureMediator!

    override func setUp() {
        let settings = RestaurantsRequestParamEntity()
        let searchResults = createRestaurantSearchResult()
        interactor = MapInteractorStub(dependency: .init(
            searchGateway: RestaurantsSearchGatewayStub(
                result: .success(searchResults)),
            requestParamGateway: RestaurantsRequestParamGatewayStub(
                result: .success(settings))
            )
        )
        
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        view = naviViewController.viewControllers[0] as? MapViewController
        let router = MapRouter(view: view)
        presenter = MapPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )
        
        mediator = MGLFeatureMediator(dependency: .init(
            presenter: presenter
            )
        )
    }
    
    func test_check_sorteMGLFeaturesResult() {
        let possibleFeatureA = MGLPointFeature()
        possibleFeatureA.coordinate = CLLocationCoordinate2DMake(34.982929, 135.773914)
        let possibleFeatureB = MGLPointFeature()
        possibleFeatureA.coordinate = CLLocationCoordinate2DMake(34.981171, 135.772111)
        let possibleFeatureC = MGLPointFeature()
        possibleFeatureA.coordinate = CLLocationCoordinate2DMake(34.982929, 135.773914)
        let possibleFeatureD = MGLPointFeature()
        possibleFeatureA.coordinate = CLLocationCoordinate2DMake(34.981171, 135.772111)
        let possibleFeatureE = MGLPointFeature()
        possibleFeatureA.coordinate = CLLocationCoordinate2DMake(34.982929, 135.773914)
        let possibleFeatureF = MGLPointFeature()
        possibleFeatureA.coordinate = CLLocationCoordinate2DMake(34.981171, 135.772111)
        let possibleFeatures = [
            possibleFeatureA,
            possibleFeatureB,
            possibleFeatureC,
            possibleFeatureD,
            possibleFeatureE,
            possibleFeatureF
        ]
        
        let expected = [
            possibleFeatureA,
            possibleFeatureC,
            possibleFeatureE,
            possibleFeatureB,
            possibleFeatureD,
            possibleFeatureF
        ]
        let actual = mediator.sorteMGLFeatures(
            features: possibleFeatures,
            center: CLLocation(latitude: 34.98216282, longitude: 135.77450012)
        )
        
        XCTAssertEqual(expected[0].coordinate.latitude, actual[0].coordinate.latitude)
        XCTAssertEqual(expected[0].coordinate.longitude, actual[0].coordinate.longitude)
        XCTAssertEqual(expected[1].coordinate.latitude, actual[1].coordinate.latitude)
        XCTAssertEqual(expected[1].coordinate.longitude, actual[1].coordinate.longitude)
        XCTAssertEqual(expected[2].coordinate.latitude, actual[2].coordinate.latitude)
        XCTAssertEqual(expected[2].coordinate.longitude, actual[2].coordinate.longitude)
        XCTAssertEqual(expected[3].coordinate.latitude, actual[3].coordinate.latitude)
        XCTAssertEqual(expected[3].coordinate.longitude, actual[3].coordinate.longitude)
        XCTAssertEqual(expected[4].coordinate.latitude, actual[4].coordinate.latitude)
        XCTAssertEqual(expected[4].coordinate.longitude, actual[4].coordinate.longitude)
        XCTAssertEqual(expected[5].coordinate.latitude, actual[5].coordinate.latitude)
        XCTAssertEqual(expected[5].coordinate.longitude, actual[5].coordinate.longitude)
    }
    
    func test_is_correctMarkerViewData_whenMGLFeatureTypeIsBusstop() {
        let busstopMGLFeature = MGLPointFeature()
        busstopMGLFeature.coordinate = CLLocationCoordinate2DMake(34.982929, 135.773914)
        busstopMGLFeature.attributes = [
            "P11_001": "五条千本",
            "P11_004_1": "81,83",
            "P11_003_1": "京都バス（株）,京阪バス（株）"
        ]
        let busstopViewData = BusstopMarkerViewData(entity: .init(
            title: "五条千本",
            coordinate: CLLocationCoordinate2DMake(34.982929, 135.773914),
            type: .busstop,
            routeNameString: "81,83",
            organizationNameString: "京都バス（株）,京阪バス（株）"
            )
        )

        let expected = CustomMGLPointAnnotation(viewData: busstopViewData)
        let actual = mediator.convertMGLFeatureToAnnotation(source: busstopMGLFeature)
        XCTAssertEqual(expected.title, actual.title)
        XCTAssertEqual(expected.subtitle, actual.subtitle)
        XCTAssertEqual(expected.coordinate.latitude, actual.coordinate.latitude)
        XCTAssertEqual(expected.coordinate.longitude, actual.coordinate.longitude)

        /// Check MarkerViewData
        let expectedViewData = expected.viewData as! BusstopMarkerViewData
        let actualViewData = actual.viewData as! BusstopMarkerViewData
        XCTAssertEqual(expectedViewData.name, actualViewData.name)
        XCTAssertEqual(expectedViewData.type, actualViewData.type)
        XCTAssertEqual(expectedViewData.detail.routes[0], actualViewData.detail.routes[0])
        XCTAssertEqual(expectedViewData.detail.routes[1], actualViewData.detail.routes[1])
        XCTAssertEqual(expectedViewData.detail.organizations[0], actualViewData.detail.organizations[0])
        XCTAssertEqual(expectedViewData.detail.organizations[1], actualViewData.detail.organizations[1])
    }
    
    override func tearDown() {
    }
}

private extension MGLFeatureMediatorTests {
    private func createRestaurantSearchResult() -> RestaurantsSearchResultEntity {
        /// Set dummy data with json file
        let path = Bundle.main.path(forResource: "gnaviAPIDummyResponse", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)

        /// decode dummy json file
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let resultEntity = try decoder.decode(RestaurantsSearchResultEntity.self, from: data)
            return resultEntity
        } catch let error {
            print("error=>\(error)")
            return RestaurantsSearchResultEntity()
        }
    }
}
