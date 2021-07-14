//
//  MySwiftUI.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/8/21.
//

import SwiftUI

@main
struct MySwiftUIApp: App {
    
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}

