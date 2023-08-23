//
//  FavouritesPageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 22/8/2023.
//

import SwiftUI

struct FavouritesPageView: View {
    var body: some View {
        VStack {
            
            
            HStack {
                // Top Buttons
                Button("Translate") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .frame(width: 100,height: 35)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(8)
                
                Button("History") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .frame(width: 100,height: 35)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(8)
                
                Button("Favourites") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .frame(width: 100,height: 35)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(8)
                
                Button {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                } label: {
                    Image(systemName: "person.fill")
                }
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(20)
                
            }
            
            
            ScrollView {
                VStack {
                    // Hitories
                    
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                    TranslateTextRow(TopText: "Top Example Text1", BottomText: "Bottom Example Text2", isFavourite: true)
                    
                }
            }
        }
    }
    
    struct FavouritesPageView_Previews: PreviewProvider {
        static var previews: some View {
            FavouritesPageView()
        }
    }
}
