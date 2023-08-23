//
//  HomePageView.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 9/8/2023.
//

import SwiftUI


struct HomePageView: View {
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
            
            Spacer()
            
            
            VStack {
                // Texting & talking Buttons
                
                TextField("Type here", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .frame(height: 40)
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Button {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                } label: {
                    Image(systemName: "mic.fill")
                        .resizable()
                        .frame(width: 35,height: 50)
                }
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(50)
                HStack {
                    // Language Switching
                    Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                        /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                    }
                    .frame(width: 100,height: 35)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(8)
                    
                    Image(systemName: "arrow.left.arrow.right")
                    
                    Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                        /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                    }
                    .frame(width: 100,height: 35)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(8)
                    
                    
                }
            }
        }
        .padding()
    }    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}



