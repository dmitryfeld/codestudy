//
//  Profile.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/10/21.
//

import Foundation
import SwiftUI

struct Profile {
    var userName: String
    var image: Image?
    var preferesNotifications = true
    var seasonalPhoto = Season.winter
    var goalDate = Date()
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "spring"
        case summer = "summer"
        case autumn = "autumn"
        case winter = "winter"
        var id: String { self.rawValue }
    }
    
    static let `default` = Profile(userName:"dfeld",image: Image.init("profile"))
}
