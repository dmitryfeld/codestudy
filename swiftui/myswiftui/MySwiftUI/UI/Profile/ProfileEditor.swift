//
//  ProfileEditor.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 4/29/21.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile : Profile
    @State var showCaptureImageView: Bool = false
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ProfileImage(
                image:profile.image,
                editable: true,
                buttonClosure: {self.showCaptureImageView.toggle()})
            List {
                HStack {
                    Text("Username").bold()
                    Divider()
                    TextField("Username",text:$profile.userName)
                }
                Toggle(isOn:$profile.preferesNotifications) {
                    Text("Enable Notifications").bold()
                }
                VStack(alignment: .leading, spacing: 20) {
                    Text("Seasonal Photo").bold()
                    
                    Picker("Seasonal Photo", selection: $profile.seasonalPhoto) {
                        ForEach(Profile.Season.allCases) { season in
                            Image(season.rawValue).tag(season)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    DatePicker(selection:$profile.goalDate, in:dateRange, displayedComponents:.date) {
                        Text("Goal Date").bold()
                    }
                }
            }
            if (showCaptureImageView) {
                CaptureImageView(isShown: $showCaptureImageView, image: $profile.image)
            }
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
