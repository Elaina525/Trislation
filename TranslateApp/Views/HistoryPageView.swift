//
//  HistoryPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import SwiftUI

struct HistoryPageView: View {
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Hitories

                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: false)
                }
            }
            Spacer()
        }
    }

    struct HistoryPageView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryPageView()
        }
    }
}
