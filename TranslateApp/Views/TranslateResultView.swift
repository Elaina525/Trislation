//
//  TranslateResultView.swift
//  TranslateApp
//
//  Created by Naruse Shiroha on 27/8/2023.
//

import SwiftUI
import CoreData

struct TranslateResultView: View {
    @Environment(\.managedObjectContext) var managedObjectContext // 获取 managedObjectContext
    @StateObject private var speechToText = SpeechToText()

    @State var originalText: String
    @State var from: String
    @State var to: String

    // translatedText is an arry of 3 strings
    // @State var translatedText: [String] = ["12", "", ""]
    @State var translatedText1: String = ""
    @State var translatedText2: String = ""
    @State var translatedText3: String = ""

    @State private var selectedTab: Int = 0
    @State var isFavourite = false
    
    @State var leftLanguage: String = "Auto"
    @State var rightLanguage: String = "Chinese"
    var translateSources = ["Baidu", "DeepL", "Azure"]
    var languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
    var shortLanguages = ["en", "es", "fr", "de", "zh", "ja", "ru", "ar"]
    var leftLanguageOptions: [String] { ["Auto"] + languages.filter { $0 != rightLanguage } }
    var rightLanguageOptions: [String] { languages.filter { $0 != leftLanguage } }

    func fetchTranslation(using translationFunction: @escaping (String, @escaping (String?, Error?) -> Void) -> Void, completion: @escaping (String?, Error?) -> Void) {
        translationFunction(originalText) { translatedText, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let translatedText = translatedText else {
                completion(nil, NSError(domain: "TranslationError", code: -1, userInfo: nil))
                return
            }
            completion(translatedText, nil)
        }
    }

    func fetchTranslations() {


        fetchTranslation(using: { text, completion in
            baiduTranslate(text: text, from: from, to: to) { translatedText, error in
                completion(translatedText, error)
            }
        }) { baiduTranslatedText, _ in
            if let baiduTranslatedText = baiduTranslatedText {
                translatedText1 = baiduTranslatedText
                print("Baidu: \(translatedText1)")
                saveToDatabase()
            }
        }
        

        fetchTranslation(using: { text, completion in
            deeplTranslate(text: text, from: from, to: to) { translatedText, error in
                completion(translatedText, error)
            }
        }) { deeplTranslatedText, _ in
            if let deeplTranslatedText = deeplTranslatedText {
                translatedText2 = deeplTranslatedText
                print("DeepL: \(translatedText2)")
                saveToDatabase()
            }
        }

        fetchTranslation(using: { text, completion in
            azureTranslate(text: text, from: from, to: to) { translatedText, error in
                completion(translatedText, error)
            }
        }) { azureTranslatedText, _ in
            if let azureTranslatedText = azureTranslatedText {
                translatedText3 = azureTranslatedText
                print("Azure: \(translatedText3)")
                saveToDatabase()
            }
        }



    }

    func saveToDatabase() {
    // 检查所有三个翻译是否都已完成
    if !translatedText1.isEmpty, !translatedText2.isEmpty, !translatedText3.isEmpty {
        // 获取数据库的上下文（这里假设您已经有一个名为 'context' 的 NSManagedObjectContext 实例）
let context = self.managedObjectContext
        // 创建一个新的 TranslatedText 对象
        let translatedText = TranslatedText(context: context)

        // 使用您提供的代码设置 TranslatedText 对象的属性
        translatedText.setValue(isFavourite, forKey: "favourite")
        translatedText.setValue(Date(), forKey: "date")
        translatedText.setValue(UUID(), forKey: "id")
        translatedText.setValue(originalText, forKey: "original_text")
        translatedText.setValue("Baidu", forKey: "source1")
        translatedText.setValue("DeepL", forKey: "source2")
        translatedText.setValue("Azure", forKey: "source3")
        translatedText.setValue(from, forKey: "source_language")
        translatedText.setValue(to, forKey: "target_language")
        translatedText.setValue(translatedText1, forKey: "translated_text1")
        translatedText.setValue(translatedText2, forKey: "translated_text2")
        translatedText.setValue(translatedText3, forKey: "translated_text3")

        // 尝试保存上下文以将新对象写入数据库
        do {
            try context.save()
        } catch {
            // 处理保存错误
            print("无法保存翻译文本: \(error)")
        }
    }
}

    var body: some View {
        VStack {                
            TextField("Enter text", text: $originalText)

                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding()
                .onSubmit {
                    fetchTranslations()
                }

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

                Spacer()
            VStack {
                Button {
                    speechToText.toggleRecording()
                    originalText = speechToText.transcript
                    if speechToText.isRecording == false {
                        speechToText.transcript = ""
                        fetchTranslations()
                    }
                    
                } label: {
                    Image(systemName: speechToText.isRecording ? "mic.slash.fill" : "mic.fill")
                        .resizable()
                        .frame(width: 35, height: 50)
                }
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(50)
                
                HStack {
                    // Language Switching
                    Picker("Left Language", selection: $leftLanguage) {
                        ForEach(leftLanguageOptions, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .frame(width: 120, height: 35)
                    .background(Color(UIColor.systemGray4))
                    .cornerRadius(8)
                    
                    Button(action: {
                        withAnimation {
                            swap(&leftLanguage, &rightLanguage)
                        }
                    }) {
                        Image(systemName: "arrow.left.arrow.right")
                    }
                    
                    Picker("Right Language", selection: $rightLanguage) {
                        ForEach(rightLanguageOptions, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .frame(width: 120, height: 35)
                    .background(Color(UIColor.systemGray4))
                    .cornerRadius(8)
                }
                .onChange(of: leftLanguage) { _ in
                    if leftLanguage == rightLanguage {
                        rightLanguage = rightLanguageOptions.first!
                    }
                }
                .onChange(of: rightLanguage) { _ in
                    if leftLanguage == rightLanguage {
                        leftLanguage = leftLanguageOptions.first!
                    }
                }
                .padding()
                Text(translatedText1)
                    .font(.system(size: 1))
                    .hidden()
            }
            
            }
            .padding(.horizontal)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: fetchTranslations)

            
            
        }
        
        
    }


struct TranslateResultView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateResultView(originalText: "Today is yours", from: "auto", to: "zh")
    }
}
