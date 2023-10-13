//
//  HistoryPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import CoreData
import SwiftUI

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
                            if currentObjectIndex > 0 {
                                previousOriginalText = translatedTexts[currentObjectIndex - 1].original_text ?? ""
                                previousObjectID = translatedTexts[currentObjectIndex - 1].id ?? nil
                            }

                            print(originalText)
                        }
                }
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $detailView) {
            VStack {
                let yOffset: CGFloat = selectedTab == 0 ? offset : -offset
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .offset(x: -160, y: 0)
                    .onTapGesture {
                        detailView.toggle()
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
