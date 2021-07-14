//
//  AllHikes.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/10/21.
//

import SwiftUI

struct HikesList: View {
    @EnvironmentObject var modelData: ModelData
    var body: some View {
        ScrollView(.vertical,showsIndicators:false) {
            ForEach(modelData.hikes) {hike_ in
                HikeView(hike: hike_)
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            }
        }
    }
}

struct HikesList_Previews: PreviewProvider {
    static var previews: some View {
        HikesList()
            .environmentObject(ModelData())
    }
}
