//
//  Badge.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/9/21.
//

import SwiftUI

struct Badge: View {
    static let rotationCount = 8
        
    var badgeSymbols: some View {
        ForEach(0..<Badge.rotationCount) { index in
            RotatedBadgeSymbol(
                angle: .degrees(Double(index) / Double(Badge.rotationCount)) * 360.0
            )
        }
        .opacity(0.5)
    }
    
    var body: some View {
        ZStack {
            BadgeBackground()
            
            GeometryReader { geometry in
                badgeSymbols
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
        .scaledToFit()
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
