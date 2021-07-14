/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view displaying information about a hike, including an elevation graph.
*/

import SwiftUI

struct HikeView: View {
    let hike: Hike
    @State private var showDetail = false
    
    private var hikeDetail: HikeDetail {
        return HikeDetail(hike: hike)
    }
    
    static var moveAndFade: AnyTransition {
        //return AnyTransition.move(edge: .trailing)
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
//        let removal = AnyTransition.scale
//            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    var body: some View {
        VStack {
            HStack {
                HikeGraph(hike: hike, path: \.elevation, hasRippleEffect: false)
                    .frame(width: 50, height: 30)
                    .animation(nil)
                
                Spacer()

                VStack(alignment: .leading) {
                    Text(hike.name)
                        .font(.headline)
                    Text(hike.distanceText)
                }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))

                Spacer()
                
                Button(action: {
                    withAnimation {//(.easeOut(duration: 0.3))
                        self.showDetail.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .padding()
                        //.animation(.easeOut(duration: 1.3))
                }
            }

            if showDetail {
                hikeDetail
                    .transition(HikeView.moveAndFade)
            }
        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HikeView(hike: ModelData().hikes[0])
                .padding()
            Spacer()
        }
    }
}
