//
//  HomePageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 9/8/2023.
//

import SwiftUI

struct HomePageView: View {
    @State private var leftLanguage = 0
    @State private var rightLanguage = 1
    private var languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
    
    @State var showSheet = false
    @State var isTranslating = false
    
    var body: some View {
        if isTranslating == false {
            VStack {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack {
                                            // Hitories
                                            
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                            TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2")
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    VStack {
                                        
                                        Button {
                                            isTranslating.toggle()
                                        } label: {
                                            Text("Type here")
                                        }
                                            .padding()
                                            .frame(width: 350, height: 40)
                                            .background(Color(UIColor.systemGray4))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    
                                        

                                        

                                        
                                        Button {
                                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                                        } label: {
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
            
            
            } else {
                VStack {
                    Image(systemName: "chevron.left")
                        .offset(x: -170, y:0)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            isTranslating.toggle()
                        }
                    TranslateResultView(originalText: "Hello World", translatedText: ["你好世界", "Hola Mundo", "Bonjour le monde"])
                }
                
        }
            
            
        
        


            
        
        
        
        
        
        
        
    }
    
    private func getLeftLanguageOptions() -> [String] {
        return languages.filter { $0 != languages[rightLanguage] }
    }
    
    private func getRightLanguageOptions() -> [String] {
        return languages.filter { $0 != languages[leftLanguage] }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
