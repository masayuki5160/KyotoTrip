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

    /// TODO: 変換処理が実装できたらView側で参照をpublishDsteForCellViewFormatに切り替える
    var publishDsteForCellViewFormat: String {
        return convertDateFormat(dateStr: publishDate)
    }
    
    /// FIXME: 曜日と月を変換できない不具合
    func convertDateFormat(dateStr: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "EEE, dd MM yyyy HH:mm:ss Z"
        if let date = inFormatter.date(from: dateStr) {
            let outFormatter = DateFormatter()
            outFormatter.dateFormat = "yyyy/MM/dd"

            return outFormatter.string(from: date)
        } else {
            return dateStr
        }
    }
}
