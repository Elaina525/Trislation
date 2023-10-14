//
//  TranslateResultView.swift
//  TranslateApp
//
//  Created by Naruse Shiroha on 27/8/2023.
//

import CoreData
import SwiftUI

struct TranslateResultView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext // 获取 managedObjectContext
    @StateObject private var speechToText = SpeechToText()

    @State var originalText: String
    // @State var from: String
    // @State var to: String

    // translatedText is an arry of 3 strings
    // @State var translatedText: [String] = ["12", "", ""]
    @State var translatedText1: String = ""
    @State var translatedText2: String = ""
    @State var translatedText3: String = ""

    @State private var selectedTab: Int = 0
    @State var isFavourite = false
    @State var settingPage = false

    @State var leftLanguage: String = "Auto"
    @State var rightLanguage: String = "Chinese"
    var translateSources = ["Google", "DeepL", "Azure"]
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
        print("from: \(leftLanguage), to: \(rightLanguage)")
        if checkDatabase() {
            return // 如果数据库中存在匹配的条目，直接返回
        }

//        fetchTranslation(using: { text, completion in
//            BaiduTranslateModel().baiduTranslate(text: text, from: leftLanguage, to: rightLanguage) { translatedText, error in
//                completion(translatedText, error)
//            }
//        }) { baiduTranslatedText, _ in
//            if let baiduTranslatedText = baiduTranslatedText {
//                translatedText1 = baiduTranslatedText
//                print("Baidu: \(translatedText1)")
//                saveToDatabase()
//            }
//        }

         fetchTranslation(using: { text, completion in
             GoogleTranslateModel().googleTranslate(text: text, from: leftLanguage, to: rightLanguage) { translatedText, error in
                 completion(translatedText, error)
             }
         }) { googleTranslatedText, _ in
             if let googleTranslatedText = googleTranslatedText {
                 translatedText1 = googleTranslatedText
                 print("Google: \(translatedText1)")
                 saveToDatabase()
             }
         }

        fetchTranslation(using: { text, completion in
            DeeplTranslateModel().deeplTranslate(text: text, from: leftLanguage, to: rightLanguage) { translatedText, error in
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
            AzureTranslateModel().azureTranslate(text: text, from: leftLanguage, to: rightLanguage) { translatedText, error in
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

    func checkDatabase() -> Bool {
        // 创建一个请求对象
        let fetchRequest: NSFetchRequest<TranslatedText> = TranslatedText.fetchRequest()
        // 设置过滤条件
        fetchRequest.predicate = NSPredicate(format: "original_text == %@ AND target_language == %@", originalText, rightLanguage)
        do {
            // 执行请求
            let results = try managedObjectContext.fetch(fetchRequest)
            // 检查是否有匹配的条目
            if let existingEntry = results.first {
                // 更新翻译结果
                translatedText1 = existingEntry.translated_text1 ?? ""
                translatedText2 = existingEntry.translated_text2 ?? ""
                translatedText3 = existingEntry.translated_text3 ?? ""
                
                isFavourite = existingEntry.favourite

                return true // 返回true表示找到了匹配的条目
            }
        } catch {
            print("查询数据库时出错: \(error)")
        }
        return false // 返回false表示没有找到匹配的条目
    }

    func updateFavouriteInDatabase() {
        let fetchRequest: NSFetchRequest<TranslatedText> = TranslatedText.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "original_text == %@", originalText)
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let existingEntry = results.first {
                existingEntry.setValue(isFavourite, forKey: "favourite")
                try managedObjectContext.save()
            }
        } catch {
            print("更新 favourite 字段时出错: \(error)")
        }
    }

    func saveToDatabase() {
        // 检查所有三个翻译是否都已完成
        if !translatedText1.isEmpty, !translatedText2.isEmpty, !translatedText3.isEmpty {
            // 获取数据库的上下文（这里假设您已经有一个名为 'context' 的 NSManagedObjectContext 实例）
            let context = managedObjectContext
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
            translatedText.setValue(leftLanguage, forKey: "source_language")
            translatedText.setValue(rightLanguage, forKey: "target_language")
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
                translatedText1 = ""
                translatedText2 = ""
                translatedText3 = ""
                fetchTranslations() // 假设您已经定义了这个函数
            }

        GeometryReader { geometry in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15) // 圆角矩形作为背景
                        .fill(Color.gray)
                        .frame(width: geometry.size.width - 40, height: 35) // 减去两侧的空间

                    RoundedRectangle(cornerRadius: 15) // 圆角矩形作为气泡
                        .fill(Color.blue)
                        .frame(width: (geometry.size.width - 40) / CGFloat(translateSources.count), height: 35)
                        .offset(x: CGFloat(selectedTab) * ((geometry.size.width - 40) / CGFloat(translateSources.count)) - (geometry.size.width - 40) / 2 + ((geometry.size.width - 40) / CGFloat(translateSources.count)) / 2)
                        .animation(.easeInOut) // 添加动画

                    HStack(spacing: 0) { // 将HStack移动到ZStack的最上层
                        ForEach(0 ..< translateSources.count, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    selectedTab = index
                                }
                            }) {
                                Text(translateSources[index])
                                    .foregroundColor(.white)
                            }
                            .frame(width: (geometry.size.width - 40) / CGFloat(translateSources.count), height: 35)
                            
                        }
                        
                    }
                    .padding(.horizontal, 20) // 在此添加水平填充
                }

                TabView(selection: $selectedTab) {
                    Text(translatedText1)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .tag(0)

                    Text(translatedText2)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .tag(1)

                    Text(translatedText3)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }

        Spacer()
        VStack {
            

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
            
            HStack(spacing: 35) {
                
                Button {
                    isFavourite.toggle()
                } label: {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.system(size: 40))
                }
                
                Button {
                    speechToText.toggleRecording(language: leftLanguage)
                    originalText = speechToText.transcript
                    if speechToText.isRecording == false {
                        speechToText.transcript = ""
                        translatedText1 = ""
                        translatedText2 = ""
                        translatedText3 = ""
                        fetchTranslations()
                    }

                } label: {
                    Image(systemName: speechToText.isRecording ? "mic.slash.fill" : "mic.fill")
                        .resizable()
                        .frame(width: 28, height: 40)
                }
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(50)
                
                Button {
                    settingPage.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 40))
                }
                .sheet(isPresented: $settingPage) {
                    SettingPageView()
                }
            }

            Text(translatedText1)
                .font(.system(size: 8.5))
                .hidden()
        }
    }
    .padding(.horizontal)
    .background(Color(UIColor.systemGray6))
    .cornerRadius(20)
    .edgesIgnoringSafeArea(.bottom)
    .onAppear(perform: fetchTranslations) // 假设您已经定义了这个函数
}
}

struct TranslateResultView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateResultView(originalText: "Today is yours", leftLanguage: "Auto", rightLanguage: "Chinese")
    }
}
