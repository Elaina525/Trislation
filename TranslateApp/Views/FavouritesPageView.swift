//
//  FavouritesPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import SwiftUI

struct FavouritesPageView: View {
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Hitories

                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                }
                
            }
            Spacer()
        }
    }

    struct FavouritesPageView_Previews: PreviewProvider {
        static var previews: some View {
            FavouritesPageView()
        }
    }
}
