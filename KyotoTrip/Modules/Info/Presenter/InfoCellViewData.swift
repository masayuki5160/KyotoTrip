//
//  InfoCellViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation

struct InfoCellViewData {
    var title = ""
    var publishDate = ""
    var link = ""
    var publishDateForCellView: String {
        return convertDateFormat(dateStr: publishDate)
    }
    
    private func convertDateFormat(dateStr: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "EEE, dd MM yyyy HH:mm:ss Z"
        inFormatter.locale = Locale(identifier: "en")
        if let date = inFormatter.date(from: dateStr) {
            let outFormatter = DateFormatter()
            outFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

            return outFormatter.string(from: date)
        } else {
            return dateStr
        }
    }
}
