//
//  HikeBadges.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/10/21.
//

import SwiftUI

struct HikeBadgeList: View {
    @EnvironmentObject var modelData: ModelData
    var importantHikes: [Hike] {
        return modelData.hikes.filter { hike_ in
            modelData.hikes.last == hike_ || modelData.hikes.first == hike_ || isSpecialHike(hike: hike_)
        }
    }
    private func getHikeName(hike:Hike, fromHikes:[Hike])->String {
        let specialDate = modelData.findSpecialDate(hike: hike)
        if fromHikes.first == hike {
            return "First Hike"
        }
        if fromHikes.last == hike {
            return "Last Hike"
        }
        if specialDate != nil {
            return specialDate!.name;
        }
        return "Funky"
    }
    private func isSpecialHike(hike:Hike)->Bool {
        var result: Bool = false;
        let specialDate = modelData.findSpecialDate(hike: hike)
        if specialDate != nil {
            result = true;
        }
        return result;
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Completed Badges:")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators:true) {
                HStack(alignment: .center, spacing: 5) {
                    ForEach(importantHikes) {hike_ in
                        let name = getHikeName(hike: hike_, fromHikes: importantHikes)
                        HikeBadge(name: name, difficulty: hike_.difficulty)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            }
        }
    }
}

struct HikeBadgeList_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadgeList()
            .environmentObject(ModelData())
    }
}
