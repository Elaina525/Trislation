//
//  TranslateResultView.swift
//  TranslateApp
//
//  Created by Naruse Shiroha on 27/8/2023.
//

import SwiftUI

struct TranslateResultView: View {
    let originalText: String
    //translatedText is an arry of 3 strings
    let translatedText: [String]
    
    @State private var selectedTab: Int = 0
    @State var isFavourite = false

    var body: some View {
        VStack{
            // a rectangle with rounded corners 10 display the original text
            // maximum long text is 2 lines
            // fixed height
            
            
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
            //Deepl, Google, Bing
            // hstack leading
            HStack {
                Button(action: {
                    selectedTab = 0
                }) {
                    Text("Deepl")
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedTab == 0 ? Color.blue : Color.gray)
                        .cornerRadius(10)
                    
                    
                }
                
                
                Button(action: {
                    selectedTab = 1
                }) {
                    Text("Google")
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedTab == 1 ? Color.blue : Color.gray)
                        .cornerRadius(10)
                    
                    
                }
                
                Button(action: {
                    selectedTab = 2
                }) {
                    Text("Bing")
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedTab == 2 ? Color.blue : Color.gray)
                        .cornerRadius(10)
                    
                    
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
                        Text(translatedText[0])
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
                        Text(translatedText[1])
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
                        Text(translatedText[2])
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
        
        
        
    }
}

struct TranslateResultView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateResultView(originalText: "Hello World", translatedText: ["你好世界", "Hola Mundo", "Bonjour le monde"])
    }
}
