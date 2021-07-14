//
//  ContentView.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    var body: some View {
        TabView(selection: $selection){
            CategoryHome()
                .tabItem {
                    Label("Featured", systemImage:"star")
                }
                .tag(Tab.featured)
            LandmarkList()
                .tabItem {
                    Label("List", systemImage:"list.bullet")
                }
                .tag(Tab.list)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let devices:[String] = ["iPhone SE (2nd generation)",
                                "iPhone XS Max",
                                "iPad Pro (9.7-inch)",
                                "iPad Pro (12.9-inch) (2nd generation)"
                                ];
        ForEach(devices, id: \.self) {
            deviceName in
                    ContentView()
                        .environmentObject(ModelData())
                        .previewDevice(PreviewDevice(rawValue: deviceName))
                        .previewDisplayName(deviceName)
        }
    }
}
