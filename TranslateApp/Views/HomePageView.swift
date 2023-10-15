import SwiftUI

/// A view for the home page of Trislation.
/**
 `HomePageView.swift` is a SwiftUI view file that represents the home page of the translation app. This view allows users to enter text for translation, select source and target languages, and initiate the translation process. It also includes options for recording speech input, accessing settings, and managing favorite translations.

 - Note:
    This view interacts with the app's data and settings, including the source and target languages, and provides a user-friendly interface for translating text and managing translation preferences.

 - Requires:
    - `SpeechToText` for speech recognition and recording.
    - AppStorage for managing source and target language settings.

 - Important Elements:
    - Text field for entering text to be translated.
    - Pickers for selecting source and target languages.
    - Buttons for recording speech input, accessing settings, and managing favorite translations.
    - Full-screen cover for displaying translation results.
 */
struct HomePageView: View {
    @StateObject private var speechToText = SpeechToText()
    @AppStorage("SourceLanguage") var sourceLanguage: String = "Auto"
    @AppStorage("TargetLanguage") var targetLanguage: String = "English"

    @State var originalText: String = ""
    @State var leftLanguage: String = "Auto"
    @State var rightLanguage: String = "English"
    @State var isTranslating = false
    @State var settingPage = false

    var translateSources = ["Baidu", "DeepL", "Azure"]
    var languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
    var leftLanguageOptions: [String] { ["Auto"] + languages.filter { $0 != rightLanguage } }
    var rightLanguageOptions: [String] { languages.filter { $0 != leftLanguage } }

    var body: some View {
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
                            .foregroundColor(.blue) // Keep the same color as the original code
                        Text("Back")
                            .foregroundColor(.blue) // Match text color to icon color
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
