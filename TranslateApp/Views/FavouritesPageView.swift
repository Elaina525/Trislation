//
//  HistoryPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import CoreData
import SwiftUI

/// A view for the favourite page of Trislation.
/**
 FavouritesPageView.swift
 TranslateApp

 This SwiftUI view is responsible for displaying users' favorite translations in the translation app. It presents a list of previously translated text entries marked as favorites, allowing users to select individual entries for detailed viewing. Users can navigate through the list of favorite translations using swipe gestures. CoreData is used to fetch and display saved translations marked as favorites.

 Key Features:
 - Display of a list showing previously translated text entries marked as favorites.
 - Full-screen cover for viewing detailed translation results.
 - Support for swipe gestures to navigate between translations.
 - Navigation buttons to return to the previous screen.

 Parameters:
 - detailView: A boolean flag to control the detail view's visibility.
 - selectedObjectID: A UUID to identify the selected translation entry.
 - originalText: The original text of the selected translation.
 - previousOriginalText: The original text of the previous translation entry.
 - from: The source language of the translation entry.
 - to: The target language of the translation entry.
 - translateSources: A list of translation sources (e.g., "Baidu," "DeepL," "Azure").
 - selectedTab: An integer indicating the selected tab or view.
 - isFavourite: A boolean flag to identify whether a translation entry is marked as a favorite.

 - Requires CoreData to manage and fetch favorite translations.

 This view enhances the translation app's user experience by allowing users to conveniently manage and view their favorite translations.
 */

struct FavouritesPageView: View {
    // 使用 @FetchRequest 从 CoreData 获取 TranslatedText 实体
    @State var detailView = false

    @State private var selectedObjectID: UUID?
    @State var originalText = ""
    @State var previousOriginalText = ""
    
    @State private var previousObjectID: UUID?
    @State var from = ""
    @State var to = ""
    var translateSources = ["Baidu", "DeepL", "Azure"]
    @State private var selectedTab: Int = 0

    @State var isFavourite = false

    @FetchRequest(
        entity: TranslatedText.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TranslatedText.date, ascending: false)],
        predicate: NSPredicate(format: "favourite == true")
    ) var translatedTexts: FetchedResults<TranslatedText>
    
    @State private var offset: CGFloat = 0.0

    var body: some View {
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(translatedTexts, id: \.self) { translatedText in
                    TranslateTextRow(data: translatedText)
                        .onTapGesture {
                            updateDetailData(translatedText)
                            guard let currentObjectIndex = translatedTexts.firstIndex(where: { $0.id == selectedObjectID }) else {
                                return
                            }
                            print(currentObjectIndex)
                            if currentObjectIndex > 0 {
                                previousOriginalText = translatedTexts[currentObjectIndex - 1].original_text ?? ""
                                previousObjectID = translatedTexts[currentObjectIndex - 1].id ?? nil
                            }

                            print(originalText)
                            

                        }
                }
                Text(originalText)
                    .hidden()
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $detailView) {
            VStack {
                let yOffset: CGFloat = selectedTab == 0 ? offset : -offset
                HStack {
                    Button(action: {
                        self.detailView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue) // 保持与原始代码的颜色一致
                            Text("Back")
                                .foregroundColor(.blue) // 使文本颜色与图标颜色相匹配
                        }
                    }
                    .offset(x: -160, y: 0)
                }
                ZStack {
                    TranslateResultView(originalText: previousOriginalText, leftLanguage: from, rightLanguage: to)
                        .id(previousObjectID)

                    TranslateResultView(originalText: originalText, leftLanguage: from, rightLanguage: to)
                        .offset(y: yOffset)
                        .id(selectedObjectID)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard let currentObjectIndex = translatedTexts.firstIndex(where: { $0.id == selectedObjectID }) else {
                                        return
                                    }
                                    // Track the offset based on the swipe gesture
                                    offset = value.translation.height
                                    if currentObjectIndex > 0 {
                                        previousOriginalText = translatedTexts[currentObjectIndex - 1].original_text ?? ""
                                        previousObjectID = translatedTexts[currentObjectIndex - 1].id ?? nil
                                    }
                                }
                                .onEnded { value in
                                    guard let currentObjectIndex = translatedTexts.firstIndex(where: { $0.id == selectedObjectID }) else {
                                        return
                                    }

                                    print(currentObjectIndex)

                                    // withAnimation {

                                    if value.translation.height > 100 {
                                        print("swipe down")
                                        // Swipe down, show the previous object
                                        if currentObjectIndex > 0 {
                                            detailView = false
                                            updateDetailData(translatedTexts[currentObjectIndex - 1])

                                            print(originalText)
                                        }
                                    } else if value.translation.height < -100 {
                                        print("swipe up")

                                        // Swipe up, show the next object
                                        if currentObjectIndex < translatedTexts.count - 1 {
                                            detailView = false

                                            updateDetailData(translatedTexts[currentObjectIndex + 1])

                                            print(originalText)
                                        }
                                    }
                                    // }
                                    offset = 0
                                }
                        )
                }
            }
        }
        
    }

    func updateDetailData(_ translatedText: TranslatedText) {
        selectedObjectID = translatedText.id
        originalText = translatedText.original_text ?? ""
        from = translatedText.source_language ?? ""
        to = translatedText.target_language ?? ""
        detailView = true
    }
    

    struct FavouritesPageView_Previews: PreviewProvider {
        static var previews: some View {
            FavouritesPageView()
        }
    }
}
