//
//  RecentHikes.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/11/21.
//

import SwiftUI

struct RecentHikes: View {
    let count: Int;
    
    @EnvironmentObject var modelData: ModelData
    var body: some View {
        ScrollView(.vertical,showsIndicators:false) {
            let hikes = modelData.hikes.suffix(count)
            ForEach(hikes) {hike_ in
                HikeView(hike: hike_)
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            }
        }
    }
}

struct RecentHikes_Previews: PreviewProvider {
    static var previews: some View {
        RecentHikes(count:2)
            .environmentObject(ModelData())
    }
}
