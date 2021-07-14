//
//  ProfileSummary.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/10/21.
//

import SwiftUI

struct ProfileSummary: View {
    var profile: Profile
    var goalDateFormatter:DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    var body: some View {
        ScrollView(.vertical,showsIndicators:false) {
            VStack(alignment: .center, spacing: 10) {
                ProfileImage(image: profile.image,editable: false,buttonClosure: {})
                Text(profile.userName)
                    .font(.title)
                    .bold()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Notifications: \(profile.preferesNotifications ? "On": "Off" )")
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
                        Text("Seasonal Photos")
                        Spacer(minLength: 10)
                        Image(profile.seasonalPhoto.rawValue)
                    }
                    Text("Goal date: \(profile.goalDate, formatter:goalDateFormatter)")
                }
                Divider()
                HikeBadgeList()
                Divider()
                VStack(alignment: .leading) {
                    Text("Recent Hikes")
                        .font(.headline)
                    RecentHikes(count: 3)
                }
            }
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileSummary(profile: Profile.default)
                .environmentObject(ModelData())
        }
    }
}
