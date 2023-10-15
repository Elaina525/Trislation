//
//  HistoryPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import CoreData
import SwiftUI

/// A view for the history page of Trislation.
/**
 `HistoryPageView.swift` is a SwiftUI view file that represents the history page of the translation app. This view displays a list of previously translated text entries stored in the CoreData database. Users can select and view the details of individual translation entries by tapping on them. It also provides swipe gestures for navigating between translations.

 - Note:
    This view leverages CoreData to fetch and display previously translated text entries and allows users to navigate through their translation history.

 - Requires:
    - `TranslateTextRow` for displaying each translation entry.
    - `TranslatedText` CoreData entity for storing translation data.
    - `TranslateResultView` for displaying translation results.
    - Gesture recognition for swipe navigation.

 - Important Elements:
    - A list displaying previously translated text entries.
    - A full-screen cover for viewing detailed translation results.
    - Swipe gestures for navigating between translations.
    - Navigation buttons for returning to the previous screen.
 */

struct HistoryPageView: View {
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
        sortDescriptors: [NSSortDescriptor(keyPath: \TranslatedText.date, ascending: false)]
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

    struct HistoryPageView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryPageView()
        }
    }
}
