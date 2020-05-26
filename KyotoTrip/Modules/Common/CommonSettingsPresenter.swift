//
//  SettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
protocol CommonSettingsPresenterProtocol {
    var restaurantsSearchRangeDictionary: [String : RestaurantsRequestParamEntity.SearchRange] { get }
    func convertToRangeString(from: RestaurantsRequestParamEntity.SearchRange) -> String
    func convertToSearchRange(rangeString: String) -> RestaurantsRequestParamEntity.SearchRange
}

struct CommonSettingsPresenter: CommonSettingsPresenterProtocol {
    typealias SearchRange = RestaurantsRequestParamEntity.SearchRange
    
    let restaurantsSearchRangeDictionary: [String : RestaurantsRequestParamEntity.SearchRange] = [
        SearchRange.range300.toString() : SearchRange.range300,
        SearchRange.range500.toString() : SearchRange.range500,
        SearchRange.range1000.toString() : SearchRange.range1000,
        SearchRange.range2000.toString() : SearchRange.range2000,
        SearchRange.range3000.toString() : SearchRange.range3000
    ]
    
    func convertToRangeString(from: RestaurantsRequestParamEntity.SearchRange) -> String {
        return from.toString()
    }
    
    func convertToSearchRange(rangeString: String) -> SearchRange {
        return restaurantsSearchRangeDictionary[rangeString]
            ?? SearchRange.range500
    }
}
