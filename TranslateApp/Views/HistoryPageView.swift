//
//  HistoryPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import SwiftUI
import CoreData

struct HistoryPageView: View {
    // 使用 @FetchRequest 从 CoreData 获取 TranslatedText 实体
    @State var detailView = false
    
    @State private var selectedObjectID: UUID?
    @State var originalText = ""
    @State var from = ""
    @State var to = ""
    var translateSources = ["Baidu", "DeepL", "Azure"]
    @State private var selectedTab: Int = 0
    
    @State var isFavourite = false
    
    @FetchRequest(
        entity: TranslatedText.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TranslatedText.date, ascending: false)]
    ) var translatedTexts: FetchedResults<TranslatedText>

    var body: some View {
        if detailView == false {
            VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            CustomVerticalLayout {

                                ForEach(translatedTexts, id: \.self) { translatedText in
                                    TranslateTextRow(data: translatedText)
                                        .onTapGesture {
                                            updateDetailData(translatedText)
                                            print(originalText)
                                        }
                                }
                            }
                        }
                        Spacer()
                    }
        } else {

            VStack {
                Image(systemName: "chevron.left")
                                    .foregroundColor(.blue)
                                    .offset(x: -160, y: 0)
                                    .onTapGesture {
                                        detailView.toggle()
                                    }
                    TranslateResultView(originalText: originalText)
                    .id(selectedObjectID)
                            .gesture(
                                            DragGesture()
                                                .onEnded { value in
                                                    guard let currentObjectIndex = translatedTexts.firstIndex(where: { $0.id == selectedObjectID }) else {
                                                            return
                                                        }
                                                    print(currentObjectIndex)

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
                                                }
                                        )
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
