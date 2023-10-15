//
//  SettingPageView.swift
//  TranslateApp
//
//  Created by Naruse Shiroha on 26/8/2023.
//

import Auth0
import SwiftUI

/// A view for the setting page of Trislation.

/**
 SettingPageView.swift
 TranslateApp

 This SwiftUI view is responsible for displaying the app's settings and user account management. It provides a user interface to adjust language preferences, enable on-device speech recognition, and manage user account information. Users can log in, log out, and reset their settings. The view also displays user account information if logged in.

 Key Features:
 - Account management with options to log in and log out.
 - Language settings for source and target languages used in translations.
 - Option to enable or disable on-device speech recognition.
 - User interface components, such as pickers and toggles, for user customization.
 - Resetting all settings to default values.
 - Profile image display for authenticated users.

 Parameters:
 - presentationMode: An environment value for controlling the presentation mode.
 - isAuthenticated: A boolean flag indicating whether the user is authenticated.
 - userProfile: User profile information, including name and email.
 - sourceLanguage: A selected source language for translations.
 - targetLanguage: A selected target language for translations.
 - onDeviceRecognition: A toggle to enable or disable on-device speech recognition.
 - languageOptions: A list of language options available for selection.
 - UserImage: A nested view for displaying user profile images.
 - login: A function to log in the user.
 - logout: A function to log out the user.

 The SettingPageView enhances user experience by allowing customization of language preferences, speech recognition settings, and user account management within the translation app.
 */


struct SettingPageView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var isAuthenticated = false
    @State var userProfile = Profile.empty

    @AppStorage("SourceLanguage") var sourceLanguage: String = "Auto"
    @AppStorage("TargetLanguage") var targetLanguage: String = "English"
    @AppStorage("OnDeviceRecognition") var onDeviceRecognition: Bool = true

    var languageOptions: [String] = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("ACCOUNT")) {
                    if isAuthenticated {
                        HStack {
                            UserImage(urlString: userProfile.picture)
                                .clipShape(Circle())
                                .frame(width: 70, height: 70)
                            VStack(alignment: .leading) {
                                Text(userProfile.name)
                                    .font(.headline)
                                Text(userProfile.email)
                                    .font(.subheadline)
                            }
                            Spacer() // 用于将 VStack 和 Button 分开
                        }

                        Button(action: logout) {
                            Text("Log out")
                                .foregroundColor(.red)
                        }
                    } else {
                        Button(action: login) {
                            Text("Log in")
                        }
                    }
                }
                Section(header: Text("Translate"), footer: Text("This setting will take effect the next time you launch the app.")) {
                    Picker(selection: $sourceLanguage, label: Text("Source Language")) {
                        Text("Auto")
                        ForEach(languageOptions, id: \.self) { language in
                            Text(language)
                        }
                    }

                    Picker(selection: $targetLanguage, label: Text("Target Language")) {
                        ForEach(languageOptions, id: \.self) { language in
                            Text(language)
                        }
                    }
                }

                // toggle to enable on device recognition
                Section(header: Text("speech recognition"), footer: Text("Enabling on-device recognition enhances privacy and reduces latency. Disabling it will rely on cloud-based recognition which is more accurate.")) {
                    Toggle(isOn: $onDeviceRecognition) {
                        Text("On Device Recognition")
                    }
                }

                // Section(header: Text("ABOUT")) {
                //     HStack {
                //         Text("Version")
                //         Spacer()
                //         Text("2.2.1")
                //     }
                // }

                Section {
                    Button(action: {
                        self.sourceLanguage = "Auto"
                        self.targetLanguage = "English"
                        self.onDeviceRecognition = true
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
        .onAppear(
            perform: {
                if let idToken = UserDefaults.standard.string(forKey: "idToken") {
                    self.isAuthenticated = true
                    self.userProfile = Profile.from(idToken)
                }
            }
        )
    }

    struct UserImage: View {
        var urlString: String

        var body: some View {
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .foregroundColor(.blue)
                    .opacity(0.5)
            }
            .padding(40) // 如果需要，可以调整这个填充值
        }
    }

    // MARK: View modifiers

    // --------------------

    struct TitleStyle: ViewModifier {
        let titleFontBold = Font.title.weight(.bold)
        let navyBlue = Color(red: 0, green: 0, blue: 0.5)

        func body(content: Content) -> some View {
            content
                .font(titleFontBold)
                .foregroundColor(navyBlue)
                .padding()
        }
    }

    struct MyButtonStyle: ButtonStyle {
        let navyBlue = Color(red: 0, green: 0, blue: 0.5)

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(navyBlue)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}

extension SettingPageView {
    func login() {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case let .failure(error):
                    print("Failed with: \(error)")

                case let .success(credentials):
                    self.isAuthenticated = true
                    self.userProfile = Profile.from(credentials.idToken)
                    print("Credentials: \(credentials)")
                    print("ID token: \(credentials.idToken)")
                    // save to app storage
                    UserDefaults.standard.set(credentials.idToken, forKey: "idToken")
                }
            }
    }

    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.isAuthenticated = false
                    self.userProfile = Profile.empty
                    print("Logged out!")
                    // remove from app storage
                    UserDefaults.standard.removeObject(forKey: "idToken")

                case let .failure(error):
                    print("Failed with: \(error)")
                }
            }
    }
}

struct SettingPageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingPageView()
    }
}
