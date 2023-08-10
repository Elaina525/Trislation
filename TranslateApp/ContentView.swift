//
//  ContentView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 2/8/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem {

                    Text("Tab 1")
                }


            Text("This is the second tab view")
                .tabItem {

                    Text("Tab 2")
                }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
