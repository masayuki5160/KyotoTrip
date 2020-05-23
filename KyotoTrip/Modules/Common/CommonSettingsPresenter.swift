//
//  SettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
protocol CommonSettingsPresenterProtocol {
    var restaurantsSearchRangeDictionary: [RestaurantsRequestParamEntity.SearchRange:String] { get }
    func convertToRangeString(from: RestaurantsRequestParamEntity.SearchRange) -> String
    func convertToSearchRange(rangeString: String) -> RestaurantsRequestParamEntity.SearchRange
}

struct CommonSettingsPresenter: CommonSettingsPresenterProtocol {
    let restaurantsSearchRangeDictionary: [RestaurantsRequestParamEntity.SearchRange:String] = [
            RestaurantsRequestParamEntity.SearchRange.range300:  "300m",
            RestaurantsRequestParamEntity.SearchRange.range500:  "500m",
            RestaurantsRequestParamEntity.SearchRange.range1000: "1000m",
            RestaurantsRequestParamEntity.SearchRange.range2000: "2000m",
            RestaurantsRequestParamEntity.SearchRange.range3000: "3000m"
    ]
    
    func convertToRangeString(from: RestaurantsRequestParamEntity.SearchRange) -> String {
        return restaurantsSearchRangeDictionary[from] ?? restaurantsSearchRangeDictionary[.range500]!
    }
    
    func convertToSearchRange(rangeString: String) -> RestaurantsRequestParamEntity.SearchRange {
        let keys = restaurantsSearchRangeDictionary.filter{ $1 == rangeString }.keys
        return keys.first ?? RestaurantsRequestParamEntity.SearchRange.range500
    }
}
