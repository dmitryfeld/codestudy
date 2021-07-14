//
//  MySwiftUI.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/8/21.
//

import SwiftUI

/*
 class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
     FirebaseApp.configure()
     return true
   }
 }
 */

@main
struct MySwiftUIApp: App {
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var modelData = ModelData()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}

