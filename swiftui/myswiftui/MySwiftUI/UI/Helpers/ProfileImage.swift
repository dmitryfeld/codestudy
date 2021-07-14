//
//  ProfileImage.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/10/21.
//

import SwiftUI

struct ProfileImage: View {
    //var imageName: String
    var image: Image?
    var editable = false
    var buttonClosure:() -> Void = {}
    
    var body: some View {
        ZStack(alignment: .center) {
            image?
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 7)
                .frame(width: 100, height: 100)
                .aspectRatio(0.75, contentMode: .fill)
            if self.editable {
                Circle()
                    .fill(Color("cameraBackground"))
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding(EdgeInsets(top: 70, leading: 70, bottom: 0, trailing: 0))
                Button(action: self.buttonClosure) {
                    Image("camera")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(EdgeInsets(top: 70, leading: 70, bottom: 0, trailing: 0))
                }
            }
        }.padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
    }
    
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(image: Image.init("profile"))
    }
}
