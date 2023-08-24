//
//  CustomLayouts.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 23/8/2023.
//

import SwiftUI

struct CustomLayouts: View {
    var body: some View {
        TranslateTextRow(TopText: "test", BottomText: "test", isFavourite: false)
    }
}

struct CustomLayouts_Previews: PreviewProvider {
    static var previews: some View {
        CustomLayouts()
    }
}

struct TranslateTextRow: View {
    let TopText: String
    let BottomText: String
    @State var isFavourite = false

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(style: StrokeStyle(lineWidth: 2))
            .frame(width: 350, height: 100)
            .foregroundColor(.black)
            .overlay {
                VStack(spacing: 10) {
                    HStack {
                        Text(TopText)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .onTapGesture {
                                isFavourite.toggle()
                            }
                    }

                    Divider()
                        .background(Color.gray)
                        .frame(height: 1)

                    Text(BottomText)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                
            }
    }
}
