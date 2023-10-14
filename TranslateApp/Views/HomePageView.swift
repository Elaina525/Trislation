import SwiftUI

enum PageState {
    case home
    case translating(String)
}

struct HomePageView: View {
    @StateObject private var speechToText = SpeechToText()
    @AppStorage("DefaultLanguage") var defaultLanguage: String = "English"

    @State var originalText: String = ""
    @State var leftLanguage: String = "Auto"
    @State var rightLanguage: String = "English"
    @State var isTranslating = false
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

                Button {
                    speechToText.toggleRecording()
                    originalText = speechToText.transcript
                    if speechToText.isRecording == false {
                        speechToText.transcript = ""
                        isTranslating.toggle()
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
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                self.rightLanguage = self.defaultLanguage
            }
            .fullScreenCover(isPresented: $isTranslating) {
            Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .offset(x: -160, y: 0)
                    .onTapGesture {
                        isTranslating.toggle()
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
