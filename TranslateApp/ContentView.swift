//
//  ContentView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 2/8/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var settingPageIsPresented = false
    
    var body: some View {
        VStack(){
            
            HStack {
                // Top Buttons
                Button("Translate") {
                    print(selectedTab)
                    selectedTab = 0
                    print(selectedTab)
                }
                .frame(width: 100,height: 35)
                .foregroundColor(.white)
                .background(selectedTab == 0 ? Color.blue : Color.gray)
                .cornerRadius(8)
                
                Button("History") {
                    print(selectedTab)
                    selectedTab = 1
                    print(selectedTab)
                }
                .frame(width: 100,height: 35)
                .foregroundColor(.white)
                .background(selectedTab == 1 ? Color.blue : Color.gray)
                .cornerRadius(8)
                
                Button("Favourites") {
                    print(selectedTab)
                    selectedTab = 2
                    print(selectedTab)
                }
                .frame(width: 100,height: 35)
                .foregroundColor(.white)
                .background(selectedTab == 2 ? Color.blue : Color.gray)
                .cornerRadius(8)
                
                Button {
                    settingPageIsPresented.toggle()
                } label: {
                    Image(systemName: "person.fill")
                }
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(20)
                .sheet(isPresented: $settingPageIsPresented) {
                    SettingPageView()
                }
                
            }
            .padding()
            TabView(selection: $selectedTab) {
                HomePageView()
                    .tag(0)
                
                HistoryPageView()
                    .tag(1)
                
                FavouritesPageView()
                    .tag(2)
            }
            .tabViewStyle((PageTabViewStyle(indexDisplayMode: .never)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

