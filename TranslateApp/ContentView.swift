//
//  ContentView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 2/8/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var topButtons: [String] = ["Translate", "History", "Favourites"]
var body: some View {
    VStack(spacing: 0) {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15) // 圆角矩形作为背景
                        .fill(Color.gray)
                        .frame(width: geometry.size.width - 40, height: 35) // 减去两侧的空间

                    RoundedRectangle(cornerRadius: 15) // 圆角矩形作为气泡
                        .fill(Color.blue)
                        .frame(width: (geometry.size.width - 40) / CGFloat(topButtons.count), height: 35)
                        .offset(x: CGFloat(selectedTab) * ((geometry.size.width - 40) / CGFloat(topButtons.count)) - (geometry.size.width - 40) / 2 + ((geometry.size.width - 40) / CGFloat(topButtons.count)) / 2)
                        .animation(.easeInOut) // 添加动画

                    HStack(spacing: 0) { // 将HStack移动到ZStack的最上层
                        ForEach(0 ..< topButtons.count, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    selectedTab = index
                                }
                            }) {
                                Text(topButtons[index])
                                    .foregroundColor(.white)
                            }
                            .frame(width: (geometry.size.width - 40) / CGFloat(topButtons.count), height: 35)
                        }
                    }
                    .padding(.horizontal, 20) // 在此添加水平填充
                }

                TabView(selection: $selectedTab) {
                    HomePageView()
                        .tag(0)

                    HistoryPageView()
                        .tag(1)

                    FavouritesPageView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: selectedTab) { newValue in // 使用 onChange 代替 onReceive
                    withAnimation {
                        self.selectedTab = newValue
                    }
                }
            }
        }
    }
    .edgesIgnoringSafeArea(.bottom)
}


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
