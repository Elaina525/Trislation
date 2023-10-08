//
//  TranslateResultView.swift
//  TranslateApp
//
//  Created by Naruse Shiroha on 27/8/2023.
//

import SwiftUI

struct TranslateResultView: View {
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

    var translateSources = ["Deepl", "Google", "Bing"]

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
            }
        }



    }

    var body: some View {
        VStack {
            // a rectangle with rounded corners 10 display the original text
            // maximum long text is 2 lines
            // fixed height
            
            Text(translatedText1)
                .font(.system(size: 1))
                .hidden()
            TextField("Enter text", text: .constant(originalText))

                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding()
                .background(Color(UIColor.systemGray5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()

            // three buttons mean 3 different translate sources
            // Deepl, Google, Bing
            // hstack leading
            HStack {
                ForEach(translateSources, id: \.self) { item in
                    Button(action: {
                        selectedTab = translateSources.firstIndex(of: item)!
                    }) {
                        Text(item)
                            .foregroundColor(.white)
                            .padding()
                            .background(selectedTab == translateSources.firstIndex(of: item)! ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                }

                Spacer()

                Image(systemName: isFavourite ? "heart.fill" : "heart")
                    .font(.system(size: 25))
                    .foregroundColor(.red)
                    .onTapGesture {
                        isFavourite.toggle()
                    }
            }
            .padding(.horizontal)

            TabView(selection: $selectedTab) {
                // Deepl
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color(UIColor.systemGray5))
                    .overlay(
                        Text(translatedText1)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding()
                    )
                    .padding()
                    .tag(0)
                // Google
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color(UIColor.systemGray5))
                    .overlay(
                        Text(translatedText2)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding()
                    )
                    .padding()
                    .tag(1)
                // Bing
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color(UIColor.systemGray5))
                    .overlay(
                        Text(translatedText3)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding()
                    )
                    .padding()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .onAppear(perform: fetchTranslations)
    }
}

struct TranslateResultView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateResultView(originalText: "Today is yours", from: "auto", to: "zh")
    }
}
