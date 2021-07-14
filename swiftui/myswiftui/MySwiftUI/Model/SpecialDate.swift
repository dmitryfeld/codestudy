//
//  SpecialDate.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/11/21.
//

import Foundation

struct SpecialDate: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var timestamp: String
    
    private var dateFormatter:DateFormatter {
        let result = DateFormatter();
        result.dateFormat = "yyyy-MM-dd"
        return result
    }
    
    var date: Date {
        let result:Date = dateFormatter.date(from: timestamp)!
        return result
    }
    
    func checkHike(hike: Hike)->Bool {
        hike.date == self.date
    }
}
