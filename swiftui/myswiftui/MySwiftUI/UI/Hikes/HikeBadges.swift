//
//  HikeBadges.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/10/21.
//

import SwiftUI

struct HikeBadgeList: View {
    let hikes: [Hike]
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Completed Hikes:")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators:true) {
                HStack(alignment: .center, spacing: 5) {
                    ForEach(hikes) {hike_ in
                        NavigationLink(destination: HikeView(hike: hike_)) {
                            HikeBadge(hike: hike_)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            }
        }
    }
}

struct HikeBadges_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadgeList(hikes: ModelData().hikes)
    }
}
