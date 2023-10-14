import SwiftUI

enum PageState {
    case home
    case translating(String)
}

struct HomePageView: View {
    @StateObject private var speechToText = SpeechToText()
    @AppStorage("SourceLanguage") var sourceLanguage: String = "Auto"
    @AppStorage("TargetLanguage") var targetLanguage: String = "English"

    @State var originalText: String = ""
    @State var leftLanguage: String = "Auto"
    @State var rightLanguage: String = "English"
    @State var isTranslating = false
    @State var settingPage = false
    // @State var from: String
    // @State var to: String

    var translateSources = ["Baidu", "DeepL", "Azure"]
    var languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
    var leftLanguageOptions: [String] { ["Auto"] + languages.filter { $0 != rightLanguage } }
    var rightLanguageOptions: [String] { languages.filter { $0 != leftLanguage } }

    var body: some View {
        //        switch currentPage {
        //        case .home:

        VStack {
            TextField("Type here", text: $originalText)
                .padding()
                .foregroundColor(.black)
                .cornerRadius(8)
                .onSubmit {
                    isTranslating.toggle()
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
                        // Nothing
                    } label: {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                            .font(.system(size: 40))
                    }

                    Button {
                        speechToText.toggleRecording(language: leftLanguage)
                        originalText = speechToText.transcript
                        if speechToText.isRecording == false {
                            speechToText.transcript = ""
                            isTranslating.toggle()
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
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
            .edgesIgnoringSafeArea(.bottom)
        }

        .onAppear {
            self.rightLanguage = self.targetLanguage
            self.leftLanguage = self.sourceLanguage
        }
        .fullScreenCover(isPresented: $isTranslating) {
            HStack {
                Button(action: {
                    self.isTranslating.toggle()
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
            TranslateResultView(originalText: originalText, leftLanguage: leftLanguage, rightLanguage: rightLanguage)
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
