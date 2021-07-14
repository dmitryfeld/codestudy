//
//  Hike.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/9/21.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine


struct Hike: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var distance: Double
    var difficulty: Int
    var timestamp: String
    var observations:[Observation]
    
    static var lengthFormatter = LengthFormatter()
    static var dateFormatter:ISO8601DateFormatter = {
        var result:ISO8601DateFormatter = ISO8601DateFormatter()
        result.timeZone = .autoupdatingCurrent
        return result
    }()
    
    var distanceText: String {
        return Hike.lengthFormatter.string(fromValue: distance, unit: .kilometer)
    }
    var difficultyText: String {
        var result: String = ""
        switch difficulty {
        case 1:
            result = "Easy"
        case 2:
            result = "Moderate"
        case 3:
            result = "Moderate with kinks"
        case 4:
            result = "Difficult"
        default:
            result = "Streneous"
        }
        return result
    }
    var date: Date {
        let result:Date = Hike.dateFormatter.date(from: timestamp)!
        return result
    }
    
    struct Observation: Hashable, Codable {
        var elevation: Range<Double>
        var pace: Range<Double>
        var heartRate: Range<Double>
        var distanceFromStart:Double
    }
}

