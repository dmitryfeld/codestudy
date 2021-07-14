//
//  HikeBadge.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/10/21.
//

import SwiftUI

struct HikeBadge: View {
    let name: String
    let difficulty: Int
    
    var hueAngle: Angle {
        var result = Angle(degrees: 0);
        switch difficulty {
        case 2:
            result = Angle(degrees: 45);
            break;
        case 1:
            result = Angle(degrees: 90);
            break;
        default:
            result = Angle(degrees: 0);
        }
        return result;
    }
    var body: some View {
        VStack(alignment: .center) {
            
            Badge()
                .frame(width: 300, height: 300, alignment: .center)
                .scaleEffect(1.0 / 3.0)
                .frame(width: 100, height: 100)
                .hueRotation(hueAngle)
            Text(name)
                .font(.caption)
                .accessibilityLabel("Badge for \(name)")
        }
    }
}

struct HikeBadge_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadge(name: "Some Hike", difficulty: 2)
    }
}
