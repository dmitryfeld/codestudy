//
//  CategoryRow.swift
//  MySwiftUI
//
//  Created by Dmitry Feld on 3/9/21.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Landmark]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators:false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) {landmark_ in
                        NavigationLink(destination: LandmarkDetail(landmark: landmark_)) {
                            CategoryItem(landmark: landmark_)
                        }
                    }
                }
            }
            .frame(height:185)
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        CategoryRow(
            categoryName: landmarks[0].category.rawValue,
            items: Array(landmarks.prefix(4)))
    }
}
