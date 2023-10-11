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

    var topButtons: [String] = ["Translate", "History", "Favourites"]
    var body: some View {
        VStack {
            HStack {
                ForEach(topButtons, id: \.self) { item in
                    Button(item) {
                        selectedTab = topButtons.firstIndex(of: item)!
                    }
                    .frame(width: 100, height: 35)
                    .foregroundColor(.white)
                    .background(selectedTab == topButtons.firstIndex(of: item)! ? Color.blue : Color.gray)
                    .cornerRadius(8)
                }

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
            
            TabView(selection: $selectedTab) {
                HomePageView(from: "auto", to: "zh")
                    .tag(0)

                HistoryPageView()
                    .tag(1)

                FavouritesPageView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }

        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
