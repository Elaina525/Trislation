//
//  SettingPageView.swift
//  TranslateApp
//
//  Created by Naruse Shiroha on 26/8/2023.
//

import SwiftUI

struct SettingPageView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var username: String = ""
    @State var password: String = ""

    @State private var previewIndex = 0
    var defaultLanguage: [String] = ["English", "Spanish", "French", "German"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Login")) {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    Button(action: {
                        print("Login tapped!")
                    }) {
                        Text("Login")
                    }
                }

                Section(header: Text("Translate")) {
                    Picker(selection: $previewIndex, label: Text("Default Language")) {
                        ForEach(0 ..< defaultLanguage.count) {
                            Text(self.defaultLanguage[$0])
                        }
                    }
                }

                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.2.1")
                    }
                }

                Section {
                    Button(action: {
                        print("Perform an action here...")
                    }) {
                        Text("Reset All Settings")
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            })
        }
    }
}

struct SettingPageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingPageView()
    }
}
