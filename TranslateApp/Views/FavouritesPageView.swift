//
//  FavouritesPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import SwiftUI
import CoreData

struct FavouritesPageView: View {

    // 使用 @FetchRequest 从 CoreData 获取 TranslatedText 实体
    @FetchRequest(
        entity: TranslatedText.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TranslatedText.original_text, ascending: true)]
    ) var translatedTexts: FetchedResults<TranslatedText>


    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                CustomVerticalLayout {
                    ForEach(translatedTexts, id: \.self) { translatedText in
                        if translatedText.favourite {
                            TranslateTextRow(data: translatedText)
                        }
                    }

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
