//
//  ModelData.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/8/21.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var landmarks: [Landmark] = load("landmarkData.json")
    var hikes: [Hike] = load("hikeData.json")
    var specialDates:[SpecialDate] = load("specialDatesData.json")
    @Published var profile = Profile.default
    
    
    var features:[Landmark] {
        return landmarks.filter {
            return $0.isFeatured
        }
    }
    
    var categories: [String:[Landmark]] {
        return Dictionary(grouping: landmarks, by: {
            return $0.category.rawValue
        })
    }
    
    func findSpecialDate(hike: Hike) -> SpecialDate? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        for specialDate in specialDates {
            if formatter.string(from: specialDate.date) == formatter.string(from: hike.date) {
                return specialDate;
            }
        }
        return nil;
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder();
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
