import SwiftUI

enum PageState {
    case home
    case translating(String)
}

struct HomePageView: View {
    @StateObject private var speechToText = SpeechToText()
    
    @State var originalText: String = ""
    @State var leftLanguage: String = "Auto"
    @State var rightLanguage: String = "Chinese"
    @State var isHidden = true
    @State var from: String
    @State var to: String
    
    // translatedText is an arry of 3 strings
    @State var translatedText1: String = ""
    @State var translatedText2: String = ""
    @State var translatedText3: String = ""
    
    @State private var selectedTab: Int = 0
    @State var isFavourite = false
    
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
        //        switch currentPage {
        //        case .home:
        VStack {
            VStack {
                
                TextField("Type here", text: $originalText)
                    .padding()
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .onSubmit {
                        fetchTranslations()
                        if isHidden == true {
                            isHidden.toggle()
                        }
                        
                    }
                Divider()
                    .opacity(isHidden ? 0 : 1)
                HStack {
                    ForEach(translateSources, id: \.self) { item in
                        Button(action: {
                            selectedTab = translateSources.firstIndex(of: item)!
                        }) {
                            Text(item)
                                .foregroundColor(selectedTab == translateSources.firstIndex(of: item)! ? Color.blue : Color.gray)
                                .padding()
                        }
                    }
                }
                .opacity(isHidden ? 0 : 1)
                TabView(selection: $selectedTab) {
                    // Baidu
                    Text(translatedText1)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .tag(0)
                    // DeepL
                    
                    Text(translatedText2)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .tag(1)
                    // Azure
                    
                    Text(translatedText3)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .tag(2)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .opacity(isHidden ? 0 : 1)
                Spacer()
                
                Button {
                    speechToText.toggleRecording()
                    originalText = speechToText.transcript
                    if speechToText.isRecording == false {
                        speechToText.transcript = ""
                        fetchTranslations()
                        if isHidden == true {
                            isHidden.toggle()
                        }
                        
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
            }
            // add rounded corner on top
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(from: "auto", to: "zh")
    }
}
