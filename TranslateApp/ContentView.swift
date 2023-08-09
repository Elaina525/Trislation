//
//  ContentView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 2/8/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            HStack {
                // Top Buttons
                
            }
            VStack {
                // Hitories
                
            }
            VStack {
                // Texting & talking Buttons
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .frame(width: 300, height: 100)
                        .foregroundColor(.black)
                        .overlay(
                            VStack(spacing: 10) {
                                Text("Top Example Text")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                
                                
                                Divider()
                                    .background(Color.gray)
                                    .frame(height: 1)
                                
                                Text("Bottom Example Text")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                            }
                                .padding()
                        )
                    
                    
                }
                .padding()
                
                
                HStack {
                    // Language Switching
                    
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
