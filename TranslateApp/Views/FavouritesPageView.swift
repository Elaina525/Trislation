//
//  HistoryPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import SwiftUI
import CoreData

struct FavouritesPageView: View {
    // 使用 @FetchRequest 从 CoreData 获取 TranslatedText 实体
    @State var detailView = false
    
    @State private var selectedObjectID: UUID?
    @State var originalText = ""
    @State var translatedText1: String = ""
    @State var translatedText2: String = ""
    @State var translatedText3: String = ""
    var translateSources = ["Baidu", "DeepL", "Azure"]
    @State private var selectedTab: Int = 0
    
    @State var isFavourite = false
    
    @FetchRequest(
        entity: TranslatedText.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TranslatedText.date, ascending: true)],
        predicate: NSPredicate(format: "favourite == true")
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
                Text(originalText)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding()
                    

                // three buttons mean 3 different translate sources
                // Deepl, Google, Bing
                // hstack leading
                Divider()
                HStack(spacing: 34) {
                    ForEach(translateSources, id: \.self) { item in
                        Button(action: {
                            selectedTab = translateSources.firstIndex(of: item)!
                        }) {
                            Text(item)
                                .foregroundColor(selectedTab == translateSources.firstIndex(of: item)! ? Color.blue : Color.gray)
                                .padding()
                        }
                    }
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .onTapGesture {
                            isFavourite.toggle()
                        }
                }
                TabView(selection: $selectedTab) {
                    // Deepl
                    
                            Text(translatedText1)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding()
                                .tag(0)
                        
                        
                    // Google
                    
                            Text(translatedText2)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding()
                                .tag(1)
                        
                        
                    // Bing
                    
                            Text(translatedText3)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding()
                                .tag(2)
                        
                        
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
            }
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
                                                updateDetailData(translatedTexts[currentObjectIndex - 1])
                                                print(originalText + ":" + translatedText1)
                                            }
                                        } else if value.translation.height < -100 {
                                            print("swipe up")

                                            // Swipe up, show the next object
                                            if currentObjectIndex < translatedTexts.count - 1 {
                                                updateDetailData(translatedTexts[currentObjectIndex + 1])
                                                print(originalText + ":" + translatedText1)
                                            }
                                        }
                                }
                        )
            
        }
        
    }

    func updateDetailData(_ translatedText: TranslatedText) {
        selectedObjectID = translatedText.id
        originalText = translatedText.original_text ?? ""
        translatedText1 = translatedText.translated_text1 ?? ""
        translatedText2 = translatedText.translated_text2 ?? ""
        translatedText3 = translatedText.translated_text3 ?? ""
        isFavourite = translatedText.favourite
        detailView = true
    }
    
    struct FavouritesPageView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryPageView()
        }
    }
}
