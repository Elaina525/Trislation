//
//  HomePageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 9/8/2023.
//
import SwiftUI

enum PageState {
    case home
    case translating(String)
}

struct HomePageView: View {
    @State private var leftLanguage = 0
    @State private var rightLanguage = 1
    private var languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]

    @State var originalText: String = ""
    @State var currentPage: PageState = .home

    var body: some View {
        switch currentPage {
        case .home:
            HomeView(originalText: $originalText, leftLanguage: $leftLanguage, rightLanguage: $rightLanguage, languages: languages, currentPage: $currentPage)
        
        case let .translating(text):
            // TranslateResultView(originalText: text)
            //     .navigationBarItems(leading: Button(action: {
            //         currentPage = .home
            //     }) {
            //         Image(systemName: "chevron.left")
            //             .font(.system(size: 20))
            //             .foregroundColor(.blue)
            //     })
            if text != "" {
                TranslateResultView(originalText: text)
                    .navigationBarItems(leading: Button(action: {
                        currentPage = .home
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    })
            } 
        }
    }
}

struct HomeView: View {
    @Binding var originalText: String
    @Binding var leftLanguage: Int
    @Binding var rightLanguage: Int
    var languages: [String]
    @Binding var currentPage: PageState

    var body: some View {
        VStack {
            VStack {
                TextField("Type here", text: $originalText)
                    .padding()
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .onSubmit {
                        currentPage = .translating(originalText)
                    }
                Spacer()
                Button {} label: {
                    Image(systemName: "mic.fill")
                        .resizable()
                        .frame(width: 35, height: 50)
                }
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(50)

                HStack {
                    // Language Switching
                    Picker(selection: $leftLanguage, label: Text("Picker")) {
                        ForEach(getLeftLanguageOptions(), id: \.self) { language in
                            Text(language).tag(languages.firstIndex(of: language)!)
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

                    Picker(selection: $rightLanguage, label: Text("Picker")) {
                        ForEach(getRightLanguageOptions(), id: \.self) { language in
                            Text(language).tag(languages.firstIndex(of: language)!)
                        }
                    }
                    .frame(width: 120, height: 35)
                    .background(Color(UIColor.systemGray4))
                    .cornerRadius(8)
                }
                .onChange(of: leftLanguage) { _ in
                    if leftLanguage == rightLanguage {
                        rightLanguage = getRightLanguageOptions().firstIndex(of: languages[leftLanguage])!
                    }
                }
                .onChange(of: rightLanguage) { _ in
                    if leftLanguage == rightLanguage {
                        leftLanguage = getLeftLanguageOptions().firstIndex(of: languages[rightLanguage])!
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

    private func getLeftLanguageOptions() -> [String] {
        return languages.filter { $0 != languages[rightLanguage] }
    }

    private func getRightLanguageOptions() -> [String] {
        return languages.filter { $0 != languages[leftLanguage] }
    }

    private func TranslateAction() {}
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
